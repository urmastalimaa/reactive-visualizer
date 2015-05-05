R = require './ramda_additions'

FACTORY_IDENTIFIER = 'f'
OPERATOR_IDENTIFIER = 'o'

identifyObservable = (baseId) ->
  R.compose(
    R.propMap('factory', R.assoc('id', baseId + FACTORY_IDENTIFIER))
    R.propMap('operators', identifyOperators(baseId))
  )

identifyOperators = (baseId) ->
  R.mapIndexed(
    R.compose(
      assocApply('args', identifyArgs)
      identifyOperator(baseId)
    )
  )

identifyOperator = R.curry (baseId, operator, index) ->
  id = baseId + FACTORY_IDENTIFIER + Array(index + 2).join(OPERATOR_IDENTIFIER)
  R.assoc('id', id, operator)

identifyArgs = (operator) ->
  R.mapIndexed(identifyArg(operator.id))(operator.args)

identifyArg = R.curry (operatorId, operatorArg, index) ->
  identifier =
    if operatorArg.observable
      R.propMap('observable', identifyObservable(operatorId + index))
    else
      R.identity

  identifier(operatorArg)

assocApply = R.curry (key, fn, value) ->
  R.assoc(key, fn(value), value)

module.exports = identifyObservable('')
