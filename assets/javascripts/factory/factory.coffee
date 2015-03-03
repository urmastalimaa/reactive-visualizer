
evaluator = (uiValuator) ->
  evalFunc: (context, id) ->
    eval("#{@contextDefinition(context)} f = #{uiValuator.textArea(id)}")

  contextDefinition: (context) ->
    return "" if R.keys(context).length == 0
    contextAssignments = R.keys(context).map (key) ->
      "#{key}=#{JSON.stringify(context[key])}"
    contextAssignment = R.join(",", contextAssignments)
    "var #{contextAssignment};"

  evalVarargsAsArray: (context, id) ->
    [].concat.apply eval("#{@contextDefinition(context)} [#{uiValuator.textArea(id)}]")

  evalInt: (context, id) ->
    eval("#{@contextDefinition(context)} #{uiValuator.textArea(id)}")

observableFactory = (evaluator, buildObservableWithContext) ->
  root:
    of: (context, id) ->
      (scheduler) ->
        Rx.Observable.of.apply(null, evaluator.evalVarargsAsArray(context, id))

    fromTime: (context, id) ->
      (scheduler) ->
        timeAndValues = evaluator.evalVarargsAsArray(context, id)[0]

        timers = R.keys(timeAndValues)
          .map (relativeTime) -> [parseInt(relativeTime), timeAndValues[relativeTime]]
          .map ([time, value]) ->
            Rx.Observable.timer(time, scheduler).map R.I(value)

        Rx.Observable.merge(timers)

  operators:
    map: (context, createParent, {id}) ->
      (scheduler) ->
        createParent(scheduler)
          .map evaluator.evalFunc(context, id)

    filter: (context, createParent, {id}) ->
      (scheduler) ->
        createParent(scheduler)
          .do -> #why is this necessary?
            1 + 1
          .filter evaluator.evalFunc(context, id)

    delay: (context, createParent, {id}) ->
      (scheduler) ->
        dueTime = evaluator.evalInt(context, id)
        createParent(scheduler)
          .delay(dueTime, scheduler)

    take: (context, createParent, {id}) ->
      (scheduler) ->
        nrOfElements = evaluator.evalInt(context, id)
        createParent(scheduler).take(nrOfElements)

    bufferWithTime: (context, createParent, {id}) ->
      (scheduler) ->
        timeWindow = evaluator.evalInt(context, id)
        createParent(scheduler).bufferWithTime(timeWindow, scheduler)

    _getFunctionDeclaration: (id) ->
      el = $("##{id}")
      container = el.children(".recursiveContainer")
      container.children(".functionDeclaration").find("textarea").val()

    flatMap: (context, createParent, structure, targetObservableId) ->
      getArgsToBind = (decl) ->
        decl.substring(decl.indexOf("(") + 1, decl.indexOf(")"))

      argToBind = getArgsToBind(@_getFunctionDeclaration(structure.id))

      (scheduler) ->
        createParent(scheduler).flatMap (value) ->
          contextArgs = {}
          contextArgs[argToBind] = value
          obs = buildObservableWithContext(contextArgs)(structure.observable)[targetObservableId](scheduler)

buildObservables = (factory, context, {root, operators})->
  rootFact = factory.root[root.type](context, root.id)

  operatorMap = {}
  previous = rootFact
  for op in operators
    if op.observable
      console.log "RECURSIVE!", op, op.observable
      rootFact = factory.operators[op.type](context, previous, op)
      previous = rootFact
      operatorMap[op.id] = rootFact
    else
      opFact = factory.operators[op.type](context, previous, op)

      previous = opFact
      operatorMap[op.id] = opFact

  R.assoc(root.id, rootFact, operatorMap)

Visualizer.buildObservable = buildObservable = R.curryN(2, (uiValuator, context) ->
  buildObservableWithContext = buildObservable(uiValuator)
  factory = observableFactory(evaluator(uiValuator), buildObservableWithContext)
  R.curry(buildObservables)(factory)(context)
)
