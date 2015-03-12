R = require 'ramda'
Roots = require '../descriptors/roots'
Operators = require '../descriptors/operators'

identifyObservable = R.curryN 2, (baseId, observable) ->
  rootId = baseId + 'r'
  recursionLevel = (rootId.match(/r/g) || []).length - 1

  if !observable.root.args?
    observable.root.args = Roots[observable.root.type].getDefaultArgs?(recursionLevel)

  root: R.assoc('id', rootId, R.pick(['type', 'args'], observable.root))
  operators: R.mapIndexed(identifyOperator(rootId)(recursionLevel), observable.operators)

identifyOperator = R.curryN 4, (rootId, recursionLevel, operator, index) ->
  id = rootId + Array(index + 2).join("o")
  definition = Operators[operator.type]

  if !operator.args?
    operator.args = definition.getDefaultArgs?(recursionLevel)

  newOperator = R.merge(R.pick(['type', 'args'], operator), id: id, recursionType: definition.recursionType)

  if Operators[operator.type].getDefaultObservable
    observable = operator.observable || definition.getDefaultObservable(recursionLevel)
    R.merge newOperator,
      observable: identifyObservable(id)(observable)
  else
    newOperator

module.exports = identifyObservable('')
