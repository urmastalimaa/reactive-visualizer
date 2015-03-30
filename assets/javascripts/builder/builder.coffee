R = require 'ramda'
Operators = require '../descriptors/operators'
Roots = require '../descriptors/roots'

buildArg = R.curryN 2, (operatorInspector, arg) ->
  if arg.functionDeclaration && arg.observable
    arg.functionDeclaration + " " + buildCode(arg.observable)(operatorInspector) + "}"
  else if arg.observable
    buildCode(arg.observable)(operatorInspector)
  else
    arg

buildArgs = R.curryN 2, (operatorInspector, args) ->
  R.mapIndexed( (argType, index) ->
    if args[index]
      buildArg(operatorInspector)(args[index])
    else if argType == 'scheduler'
      'scheduler'
    else
      'null'
  )

rootEvaluators = R.mapObjIndexed( ({argTypes}, key) ->
  (args) ->
    (id, operatorInspector) ->
      argTypes = Roots[key].argTypes
      operatorInspector(id,
      "Rx.Observable.#{key}(#{
        R.join(',')(buildArgs(operatorInspector, args)(argTypes))
      })")
  )(Roots)

operatorEvaluators = R.mapObjIndexed( ({argTypes}, key) ->
  (args) ->
    (id, operatorInspector) ->
      argTypes = Operators[key].argTypes
      operatorInspector(id,
      ".#{key}(#{
        R.join(',')(buildArgs(operatorInspector, args)(argTypes))
      })")
  )(Operators)

evalRoot = R.curryN 2, (operatorInspector, {id, type, args}) ->
  rootEvaluators[type](args)(id, operatorInspector)

evalOperator = R.curryN 2, (operatorInspector, {id, type, args, observable}) ->
  operatorEvaluators[type](args)(id, operatorInspector)

buildCode = ({root, operators}) ->
  (operatorInspector) ->
    evalRoot(operatorInspector)(root) +
      R.join('', R.map(evalOperator(operatorInspector))(operators))

module.exports = buildCode
