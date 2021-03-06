R = require './ramda_additions'

Factories = require './descriptors/factories'
Operators = require './descriptors/operators'

serializeObservable = (recursionLevel) ->
  R.compose(
    R.propMap('factory', serializeFactory(recursionLevel))
    R.propMap('operators', R.map(serializeOperator(recursionLevel)))
  )

serializeFactory = R.curry (recursionLevel, factory) ->
  R.assoc(
    'args',
    serializeArgs(recursionLevel)(factory.args || Factories[factory.type].args)
    factory
  )

serializeOperator = R.curry (recursionLevel, operator) ->
  R.assoc(
    'args',
    serializeArgs(recursionLevel)(operator.args || Operators[operator.type].args),
    operator
  )

serializeArgs = (recursionLevel) ->
  R.map(serializeArg(recursionLevel))

serializeArg = R.curry (recursionLevel, getArg) ->
  selectArgSerializer(getArg)(recursionLevel)(getArg)

selectArgSerializer = (arg) ->
  if arg.functionDeclaration
    serializeFunctionDeclarationArg
  else if arg.observable
    serializeObservableArg
  else
    serializeSimpleArg

serializeSimpleArg = (recursionLevel) ->
  R.compose(
    R.flip(R.call)([recursionLevel])
    R.ensureFunction
  )

serializeFunctionDeclarationArg = (recursionLevel) ->
  R.compose(
    R.propMap('functionDeclaration', serializeSimpleArg(recursionLevel + 1))
    R.propMap('observable', serializeObservable(recursionLevel + 1 ))
  )

serializeObservableArg = (recursionLevel) ->
  R.propMap('observable', serializeObservable(recursionLevel + 1))

module.exports =
  serializeObservable: serializeObservable
  serializeOperator: serializeOperator
  serializeFactory: serializeFactory
