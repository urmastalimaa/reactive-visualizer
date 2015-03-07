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
      previousString + createObservableString(description.observable, (innerObservable) ->
        wrap(description.populated + innerObservable + " })")
      ) + ".do(createMockObserver(scheduler, collector.collect, '#{description.id}'))"
    else
      createOperatorString(previousString, description.populated) +
      ".do(createMockObserver(scheduler, collector.collect, '#{description.id}'))"
  )(root.populated + ".do(createMockObserver(scheduler, collector.collect, '#{root.id}'))")(operators)

  wrap(observableString)


buildObservables = (observable) ->
  observableString = createObservableString(observable, R.I)

  collector = createCollector()
  factory = R.curryN 2, (collector, scheduler) ->
    eval(observableString)

  [factory(collector), collector]

Visualizer.buildObservable = buildObservables
