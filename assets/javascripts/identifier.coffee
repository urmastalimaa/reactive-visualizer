R = require './ramda_additions'

identifyObservable = (baseId) ->
  R.compose(
    R.propMap('factory', R.assoc('id', baseId + 'r'))
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
  R.assoc('id', baseId + 'r' + Array(index + 2).join("o"), operator)

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
