Rx = require 'rx/index.js'
R = require 'ramda'

Rx.Observable.fromTime = (timesAndValues, scheduler) ->
  timers = R.keys(timesAndValues)
    .map (relativeTime) -> [parseInt(relativeTime), timesAndValues[relativeTime]]
    .map ([time, value]) ->
      # 1 is substracted at the moment to not distract users
      # with a 1ms delay due to test scheduler
      Rx.Observable.timer(Math.max(time - 1, 0), scheduler).map R.I(value)

  Rx.Observable.merge(timers)

module.exports = Rx
