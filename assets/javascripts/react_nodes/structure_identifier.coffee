V = Visualizer
N = V.ReactNodes

identifyObservable = R.curryN 2, (baseId, observable) ->
  rootId = baseId + 'r'

  root: R.assoc('id', rootId, R.pick(['type', 'args'], observable.root))
  operators: R.mapIndexed(identifyOperator(rootId), observable.operators)

identifyOperator = R.curryN 2, (rootId, operator, index) ->
  operatorId = rootId + Array(index + 2).join("o")
  recursionLevel = (rootId.match(/r/g) || []).length

  newOperator = R.assoc('id', operatorId, R.pick(['type', 'args'], operator))

  if N.Operators[operator.type].getDefaultObservable
    observable = operator.observable || N.Operators[operator.type].getDefaultObservable(recursionLevel)
    R.mixin newOperator,
      recursionType: N.Operators[operator.type].recursionType
      observable: identifyObservable(operatorId)(observable)
  else
    newOperator

V.identifyStructure = identifyObservable('')
