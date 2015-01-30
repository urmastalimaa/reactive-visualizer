
evaluator = (uiValuator) ->
  evalFunc: (id) ->
    eval("a = function(value) { #{uiValuator.textArea(id)} }")

  evalVarargsAsArray: (id) ->
    [].concat.apply eval("[#{uiValuator.textArea(id)}]")

  evalInt: (id) ->
    eval(uiValuator.textArea(id))

observableFactory = (evaluator) ->
  root:
    of: (id) ->
      (scheduler) ->
        Rx.Observable.of.apply(null, evaluator.evalVarargsAsArray(id))

  operators:
    map: (createParent, id) ->
      (scheduler) ->
        createParent(scheduler)
          .map evaluator.evalFunc(id)

    filter: (createParent, id) ->
      (scheduler) ->
        createParent(scheduler)
          .do -> #why is this necessary?
            1 + 1
          .filter evaluator.evalFunc(id)

    delay: (createParent, id) ->
      (scheduler) ->
        dueTime = evaluator.evalInt(id)
        createParent(scheduler)
          .delay(dueTime, scheduler)

buildObservables = (factory, {root, operators})->
  rootFact = factory.root[root.type](root.id)

  operatorMap = {}
  previous = rootFact
  for op in operators
    opFact = factory.operators[op.type](previous, op.id)
    previous = opFact
    operatorMap[op.id] = opFact

  R.assoc(root.id, rootFact, operatorMap)

Visualizer.buildObservable = (uiValuator) ->
  factory = observableFactory(evaluator(uiValuator))
  R.curry(buildObservables)(factory)
