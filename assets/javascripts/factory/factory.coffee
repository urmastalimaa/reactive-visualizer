R = require 'ramda'
Rx = require 'rx'
Rx = require 'rx/dist/rx.testing'
require '../custom_rx_operators'

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
