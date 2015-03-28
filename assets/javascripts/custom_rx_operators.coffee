Rx = require 'rx/index.js'
R = require 'ramda'

Rx.Observable.fromTime = (timesAndValues, scheduler) ->
  timers = R.keys(timesAndValues)
    .map (relativeTime) -> [parseInt(relativeTime), timesAndValues[relativeTime]]
    .map ([time, value]) ->
      Rx.Observable.timer(time, scheduler).map R.identity(value)

  Rx.Observable.merge(timers)

module.exports = Rx
