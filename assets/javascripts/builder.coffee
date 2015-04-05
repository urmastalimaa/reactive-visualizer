R = require 'ramda'
Operators = require './descriptors/operators'
Factories = require './descriptors/factories'

buildObservable = ({factory, operators}) ->
  (operatorInspector) ->
    buildFactories(operatorInspector)(factory) +
      R.join('', R.map(buildOperator(operatorInspector))(operators))

buildFactories = R.curry (operatorInspector, {id, type, args}) ->
  factory[type](args)(id, operatorInspector)

buildOperator = R.curry (operatorInspector, {id, type, args, observable}) ->
  operatorEvaluators[type](args)(id, operatorInspector)

buildArg = R.curry (operatorInspector, arg) ->
  if arg.functionDeclaration && arg.observable
    arg.functionDeclaration + " " + buildObservable(arg.observable)(operatorInspector) + "}"
  else if arg.observable
    buildObservable(arg.observable)(operatorInspector)
  else
    arg

buildArgs = R.curry (operatorInspector, args) ->
  R.mapIndexed( (argType, index) ->
    if args[index]
      buildArg(operatorInspector)(args[index])
    else if argType == 'scheduler'
      'scheduler'
    else
      'null'
  )

factory = R.mapObjIndexed( ({argTypes}, key) ->
  (args) ->
    (id, operatorInspector) ->
      argTypes = Factories[key].argTypes
      operatorInspector(id,
      "Rx.Observable.#{key}(#{
        R.join(',')(buildArgs(operatorInspector, args)(argTypes))
      })")
  )(Factories)

operatorEvaluators = R.mapObjIndexed( ({argTypes}, key) ->
  (args) ->
    (id, operatorInspector) ->
      argTypes = Operators[key].argTypes
      operatorInspector(id,
      ".#{key}(#{
        R.join(',')(buildArgs(operatorInspector, args)(argTypes))
      })")
  )(Operators)


module.exports = buildObservable
