V = Visualizer
N = V.ReactNodes

identifyObservable = R.curryN 2, (baseId, observable) ->
  rootId = baseId + 'r'
  recursionLevel = (rootId.match(/r/g) || []).length - 1

  observable.root.args ?= V.Roots[observable.root.type].getDefaultArgs?(recursionLevel)

  root: R.assoc('id', rootId, R.pick(['type', 'args'], observable.root))
  operators: R.mapIndexed(identifyOperator(rootId)(recursionLevel), observable.operators)

identifyOperator = R.curryN 4, (rootId, recursionLevel, operator, index) ->
  operatorId = rootId + Array(index + 2).join("o")

  operator.args ?= V.Operators[operator.type].getDefaultArgs?(recursionLevel)

  newOperator = R.mixin(R.pick(['type', 'args'], operator), id: operatorId)

  if V.Operators[operator.type].getDefaultObservable
    observable = operator.observable || V.Operators[operator.type].getDefaultObservable(recursionLevel)
    R.mixin newOperator,
      recursionType: V.Operators[operator.type].recursionType
      observable: identifyObservable(operatorId)(observable)
  else
    newOperator

V.identifyStructure = identifyObservable('')
