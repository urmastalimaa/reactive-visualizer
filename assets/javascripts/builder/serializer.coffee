R = require 'ramda'
Roots = require '../descriptors/roots'
Operators = require '../descriptors/operators'

identify = require './identifier'

callNth = ->
  args = Array.prototype.slice.call(arguments)
  ->
    arguments[args[0]](args.slice(1)...)

wrapSimpleValueInFunction = (val) ->
  if (typeof val is 'function') || val.functionDeclaration
    val
  else
    R.always(val)

serializeObservable = R.curry (recursionLevel, observable) ->
  {root, operators} = observable

  root: serializeRoot(recursionLevel, root)
  operators: R.mapIndexed(serializeOperator(recursionLevel), operators)

serializeRoot = (recursionLevel, root) ->
  rootArgs = R.compose(
    R.map(callNth(0, recursionLevel))
    R.map(wrapSimpleValueInFunction)
  )(root.args || Roots[root.type].args)

  { type: root.type, args: rootArgs }

serializeOperatorArgs = (recursionLevel, operator) ->
  R.mapIndexed( (getArg, index) ->
    if getArg.functionDeclaration && getArg.observable
      functionDeclaration =
        if (typeof getArg.functionDeclaration is 'function')
          getArg.functionDeclaration(recursionLevel + 1)
        else
          getArg.functionDeclaration
      # A function returning an observable
      functionDeclaration: functionDeclaration
      observable: serializeObservable(recursionLevel + 1)(getArg.observable)
    else
      arg = getArg(recursionLevel)
      if arg.root && arg.operators
        # A naked observable
        serializeObservable(recursionLevel + 1)(arg)
      else
        arg
  )

serializeOperator = R.curry (recursionLevel, operator, index) ->
  definition = Operators[operator.type]

  argsToUse = operator.args || definition.args

  finalArgs =
    if typeof argsToUse is 'function'
      argsToUse(recursionLevel)
    else
      argsToUse

  operatorArgs = R.compose(
    serializeOperatorArgs(recursionLevel, operator)
    R.map(wrapSimpleValueInFunction)
  )(finalArgs)

  { type: operator.type, args: operatorArgs }

module.exports = R.compose(
  identify
  serializeObservable(0)
)

