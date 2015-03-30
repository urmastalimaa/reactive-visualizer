R = require 'ramda'

assocApply = R.curry (key, fn, value) ->
  R.assoc(key, fn(value), value)

identifyArg = R.curry (operatorId, operatorArg, index) ->
  if operatorArg.observable
    R.merge(operatorArg, observable: identifyObservable(operatorId + index, operatorArg.observable))
  else if operatorArg.root && operatorArg.operators
    identifyObservable(operatorId + index, operatorArg)
  else
    operatorArg

identifyArgs = (operator) ->
  R.mapIndexed(identifyArg(operator.id))(operator.args)

identifyOperator = R.curry (baseId, operator, index) ->
  R.assoc('id', baseId + 'r' + Array(index + 2).join("o"), operator)

identifyOperators = (baseId) ->
  R.mapIndexed(
    R.compose(
      assocApply('args', identifyArgs)
      identifyOperator(baseId)
    )
  )

identifyObservable = R.curry (baseId, obs) ->
  root: R.assoc('id', baseId + 'r', obs.root)
  operators: identifyOperators(baseId)(obs.operators)

module.exports = identifyObservable('')
