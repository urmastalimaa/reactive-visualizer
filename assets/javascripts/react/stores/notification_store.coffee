R = require 'ramda'
Rx = require 'rx'
BaseStore = require './base_store'

class NotificationStore extends BaseStore

  MAX_NR_OF_RELEVANT_TIMES = 5

  _relevantNotifications = {}
  _relevantCounts = {}

  _disposable = Rx.Disposable.empty

  earliestTimeAfter = (startTime) ->
    R.compose(
      R.min
      R.filter(R.lt(startTime))
      R.pluck('time')
      R.flatten
      R.values
    )

  takeFitting = R.curryN 2, (timeKeys, timeCounts) ->
    sums = R.scan((acc, key) ->
      acc + timeCounts[key]
    )(0)(R.reverse(timeKeys))

    maxCount = Math.max(R.compose(
      R.flip(R.indexOf)(sums)
      R.max
      R.filter(R.gte(MAX_NR_OF_RELEVANT_TIMES))
    )(sums), 1)

    takeLast(maxCount, timeKeys)

  takeLast = (count, vals) ->
    end = R.length(vals)
    start = Math.max(0, end - count)
    R.slice(start, end)(vals)

  countTimes: R.compose(
    R.reduce((acc, countedTimes) ->
      res = R.clone(acc)
      for key, val of countedTimes
        res[key] =
          if res[key]?
            res[key] = Math.max(res[key], val)
          else
            val
      res
    )({})
    R.map(R.countBy(R.prop('time'))),
    R.values
  )

  filterRelevant: R.curryN 1, (relevantCounts) ->
    R.mapObj( (notificationsByKey) ->
      R.mapObjIndexed( (count, time) ->
        values:
          R.filter(R.propEq('time', parseInt(time)))(notificationsByKey)
        count:
          count
      )(relevantCounts)
    )

  init: (notifications, currentTime) ->
    timeCounts = @countTimes(notifications)
    relevantTimes = R.filter(R.gte(currentTime))(R.keys(timeCounts))
    fittingTimes = takeFitting(relevantTimes, timeCounts)
    _relevantCounts = R.pick(fittingTimes, timeCounts)
    _relevantNotifications = @filterRelevant(_relevantCounts)(notifications)
    @emitChange()

  play: (notifications, startTime = 0, callback) ->
    _disposable.dispose()

    times = R.compose(
      R.uniq
      R.sortBy(R.identity)
      R.filter(R.lt(startTime))
      R.pluck('time')
      R.flatten
      R.values
    )(notifications)

    bindedInit = R.curryN(2, @init)(notifications).bind(@)
    subscriber = (time) ->
      bindedInit(time)
      callback?(time)

    timeObservable = Rx.Observable.fromArray(times)
      .flatMap((time) ->
        Rx.Observable.timer(time - startTime).map(R.always(time))
      )

    _disposable = timeObservable.subscribe(subscriber)

  setVirtualTime: (time, notifications) ->
    _disposable.dispose()
    @init(notifications, time)

  getCurrentNotifications: (id) ->
    _relevantNotifications[id] || []

  getCurrentTimeCounts: ->
    _relevantCounts

module.exports = new NotificationStore
