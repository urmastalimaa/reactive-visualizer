Rx = require 'rx'
R = require 'ramda'

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
    resultMap[id] ?= []
    resultMap[id].push notification
  results: -> resultMap

createDoOperator = (id) ->
  ".do(createMockObserver(scheduler, collector.collect, '#{id}'))"

buildOperator = (previousCode, {id, observable, getCode}) ->
  previousCode + (
    if observable
      buildObservable(observable, getCode)
    else
      getCode()
  ) + createDoOperator(id)

buildRoot = ({id, getCode}) ->
  getCode() + createDoOperator(id)

buildObservable = ({operators, root}, wrap) ->
  wrap(R.reduce(buildOperator, buildRoot(root))(operators))

evalFactory = R.curryN 3, (observable, collector, scheduler) ->
  try
    eval(buildObservable(observable, R.I))
  catch err
    console.error "Error during evaluation", err
    Rx.Observable.empty()

module.exports = (observable) ->
  collector = createCollector()
  [evalFactory(observable, collector), collector]
