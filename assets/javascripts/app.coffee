uiValuator =
  textArea: (id) ->
    $("##{id} .source textarea").val()

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

currentObservableStructure = ->
  root: {id: 'of', type: 'of'}
  operators: [
    {id: 'map', type: 'map'}
    {id: 'delay', type: 'delay'}
    {id: 'filter', type: 'filter'}
  ]

runObservables = (observableFactories) ->
  R.foldl((map, key) ->
    scheduler = new Rx.TestScheduler
    results = scheduler.startWithTiming ->
      observableFactories[key](scheduler)
    , 0, 0, 100000

    R.assoc(key, results, map)
  )({}, R.keys(observableFactories))

messageDisplayer = ->
  onTime = (time, cb) ->
    setTimeout cb, 200 + time

  value: (key, time, value) ->
    onTime time, ->
      $("##{key} .value").html(JSON.stringify(value))

  error: (key, time, error) ->
    onTime time, ->
      $("##{key} .error").html(JSON.stringify(error))

  complete: (key, time) ->
    onTime time, ->
      $("##{key} .complete").html("C")

resultDisplayer = (messageDisplayer) ->
  display: (results) ->
    for key, result of results
      for message in result.messages
        switch message.value.kind
          when "N" then messageDisplayer.value(key, message.time, message.value.value)
          when "E" then messageDisplayer.error(key, message.time, message.value.error)
          when "C" then messageDisplayer.complete(key, message.time)

$(document).ready ->
  $("#start").click ->
    factory = observableFactory(evaluator(uiValuator))
    displayer = resultDisplayer(messageDisplayer())
    displayer.display runObservables(buildObservables(factory, currentObservableStructure()))

  $("#start").click()

