R = require 'ramda'
Rx = require '../custom_rx_operators'

createMockObserver = (scheduler, collect, id) ->
  Rx.Observer.create(
    (value) -> collect(id,
      Rx.ReactiveTest.onNext(scheduler.clock, value))
    (error) -> collect(id,
        Rx.ReactiveTest.onError(scheduler.clock, error))
    -> collect(id,
        Rx.ReactiveTest.onCompleted(scheduler.clock))
  )

createCollector = ->
  resultMap = {}

  collect: (id, notification) ->
    resultMap[id] ?= []
    resultMap[id].push notification
  results: -> resultMap

createDoOperator = (id) ->
  ".do(createMockObserver(scheduler, collector.collect, '#{id}'))"

inspect = R.curryN 3, (buildObservable, collector, scheduler) ->
  try
    observable = buildObservable R.curryN 2, (id, op) ->
      op + createDoOperator(id)
    eval(observable)
  catch err
    console.error "Error during evaluation", err
    Rx.Observable.empty()

module.exports = (buildObservable) ->
  collector = createCollector()
  [inspect(buildObservable, collector), collector]
