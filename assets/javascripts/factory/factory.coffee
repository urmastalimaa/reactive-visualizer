createMockObserver = (scheduler, collect, id) ->
  Rx.Observer.create(
    (value) -> collect(id,
      new Rx.Recorded(scheduler.clock, Rx.Notification.createOnNext(value)))
    (error) -> collect(id,
        new Rx.Recorded(scheduler.clock, Rx.Notification.createOnError(error)))
    -> collect(id,
        new Rx.Recorded(scheduler.clock, Rx.Notification.createOnCompleted()))
  )

createCollector = ->
  resultMap = {}

  collect: (id, notification) ->
    resultMap[id] ?= {}
    resultMap[id].messages ?= []
    resultMap[id].messages.push notification
  results: -> resultMap

createOperatorString = (previous, observableString) ->
  previous + observableString

createObservableString = (observable, wrap) ->
  {operators, root} = observable
  observableString = R.foldl( (previousString, description) ->
    if description.observable
      wrapper = switch description.recursionType
        when 'function'
        then ((innerObservable) -> description.code + innerObservable + " })")
        when 'observable'
        then ((innerObservable) -> description.code + innerObservable + ")")

      previousString +
        createObservableString(description.observable, wrapper) +
        ".do(createMockObserver(scheduler, collector.collect, '#{description.id}'))"
    else
      createOperatorString(previousString, description.code) +
      ".do(createMockObserver(scheduler, collector.collect, '#{description.id}'))"
  )(root.code + ".do(createMockObserver(scheduler, collector.collect, '#{root.id}'))")(operators)

  wrap(observableString)

buildObservables = (observable) ->
  observableString = createObservableString(observable, R.I)

  collector = createCollector()
  factory = R.curryN 2, (collector, scheduler) ->
    try
      eval(observableString)
    catch err
      console.error "Error during evaluation", err
      Rx.Observable.empty()

  [factory(collector), collector]

Visualizer.buildObservable = buildObservables
