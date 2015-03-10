V = Visualizer

identifyObservable = R.curryN 2, (baseId, observable) ->
  rootId = baseId + 'r'
  recursionLevel = (rootId.match(/r/g) || []).length - 1

  observable.root.args ?= V.Roots[observable.root.type].getDefaultArgs?(recursionLevel)

  root: R.assoc('id', rootId, R.pick(['type', 'args'], observable.root))
  operators: R.mapIndexed(identifyOperator(rootId)(recursionLevel), observable.operators)

identifyOperator = R.curryN 4, (rootId, recursionLevel, operator, index) ->
  id = rootId + Array(index + 2).join("o")
  definition = V.Operators[operator.type]

  args = operator.args?  && operator.args || definition.getDefaultArgs?(recursionLevel)

  newOperator = R.mixin(R.pick(['type'], operator), id: id, args: args, recursionType: definition.recursionType)

  if V.Operators[operator.type].getDefaultObservable
    observable = operator.observable || definition.getDefaultObservable(recursionLevel)
    R.mixin newOperator,
      observable: identifyObservable(id)(observable)
  else
    newOperator

V.identifyStructure = identifyObservable('')
