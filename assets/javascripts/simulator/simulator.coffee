Rx = require 'rx'
Rx = require 'rx/dist/rx.testing'

collectResults = ([observableFactory, collector]) ->
  scheduler = new Rx.TestScheduler
  results = scheduler.startWithTiming ->
    observableFactory(scheduler)
  , 0, 0, 100000

  collector.results()

module.exports = collectResults
