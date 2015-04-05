Rx = require 'rx/index.js'

collectResults = ([observableFactory, collector]) ->
  scheduler = new Rx.TestScheduler
  try
    results = scheduler.startWithTiming ->
      observableFactory(scheduler)
    , 0, 0, 30000
    collector.results()
  catch error
    error: error

module.exports = collectResults
