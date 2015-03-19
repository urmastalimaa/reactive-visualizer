R = require 'ramda'
Roots = require '../descriptors/roots'
Operators = require '../descriptors/operators'

callNth = ->
  args = Array.prototype.slice.call(arguments)
  ->
    arguments[args[0]](args.slice(1)...)

wrapSimpleValueInFunction = (val) ->
  if (typeof val is 'function') || val.functionDeclaration
    val
  else
    R.always(val)

serializeObservable = R.curryN 3, (baseId, recursionLevel, observable) ->
  {root, operators} = observable
  rootId = baseId + 'r'

  root: serializeRoot(rootId, recursionLevel, root)
  operators: R.mapIndexed(serializeOperator(rootId)(recursionLevel), operators)

serializeRoot = (id, recursionLevel, root) ->
  rootArgs = R.compose(
    R.map(callNth(0, recursionLevel))
    R.map(wrapSimpleValueInFunction)
  )(root.args || Roots[root.type].args)

  { type: root.type, id: id, args: rootArgs }

serializeOperatorArgs = (id, recursionLevel, operator) ->
  R.mapIndexed( (getArg, index) ->
    if getArg.functionDeclaration && getArg.observable
      # A function returning an observable
      functionDeclaration: getArg.functionDeclaration(recursionLevel + 1)
      observable: serializeObservable(id + index, recursionLevel + 1)(getArg.observable)
    else
      arg = getArg(recursionLevel)
      if arg.root && arg.operators
        # A naked observable
        serializeObservable(id + index, recursionLevel + 1)(arg)
      else
        arg
  )

serializeOperator = R.curryN 4, (rootId, recursionLevel, operator, index) ->
  definition = Operators[operator.type]
  id = rootId + Array(index + 2).join("o")

  argsToUse = operator.args || definition.args

  finalArgs =
    if typeof argsToUse is 'function'
      argsToUse(recursionLevel)
    else
      argsToUse

  operatorArgs = R.compose(
    serializeOperatorArgs(id, recursionLevel, operator)
    R.map(wrapSimpleValueInFunction)
  )(finalArgs)

  { type: operator.type, id: id, args: operatorArgs }

module.exports = serializeObservable('', 0)

# operators
#
# Every argument is described by a function which takes two arguments.
# Firstly recursion depth and secondly a callback to serialize an observable
#
# before serialization:
#
# operators: [
#   type: x
#   getArgs: [
#     R.always('1000'),
#     R.always(root: {}, operators: [])
#     (recursionLevel, serializeObservable) ->
#       functionDeclaration: 'value' + recursionLevel
#       observable: serializeObservable(root: {}, operators: [])
#   ]
# ]
#
# During serialization the operators are given id's and the arguments are resolved.
# If no arguments were provided then default arguments
# provided by the operator description are used
#
# after serialization:
#
# operators: [
#   id: 'ro'
#   type: x
#   args: [
#     '1000',
#     { root: {id: 'ro1r'}, operators: [{id: 'ro1ro'}] },
#     { functionDeclaration: 'x', observable: { root: {id: 'ro2r'}, operators: [{'ro2ro'] } }
#   ]
# ]
