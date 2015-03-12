R = require 'ramda'
Rx = require 'rx'
Dispatcher = require '../dispatcher/dispatcher'
BaseStore = require './base_store'

ActionTypes =
  RECEIVE_VIRTUAL_TIME: 'receive_virtual_time'
  PLAY_VIRTUAL_TIME: 'play_virtual_time'

class NotificationStore extends BaseStore

  MAX_NR_OF_RELEVANT_TIMES = 5

  _relevantNotifications = {}
  _relevantCounts = {}

  _disposable = new Rx.SerialDisposable

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

    maxCount = R.compose(
      R.flip(R.indexOf)(sums)
      R.max
      R.filter(R.gte(MAX_NR_OF_RELEVANT_TIMES))
    )(sums)

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
    R.map(R.countBy(R.get('time'))),
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

  startTimer: (notifications, currentTime) ->
    _disposable.dispose()
    _disposable = new Rx.SerialDisposable
    startTime = currentTime || 0
    nextTime = earliestTimeAfter(startTime)(notifications)
    if (nextTime != Infinity)
      _disposable.setDisposable(
        Rx.Observable.timer(nextTime - startTime)
          .subscribe =>
            @init(notifications, nextTime)
            @startTimer(notifications, nextTime))

  setVirtualTime: (time, notifications) ->
    _disposable.dispose()
    @init(notifications, time)

  getCurrentNotifications: (id) ->
    _relevantNotifications[id] || []

  getCurrentTimeCounts: ->
    _relevantCounts

notificationStore = new NotificationStore

notificationStore.dispatchToken = Dispatcher.register (action) ->
  switch action.type
    when ActionTypes.RECEIVE_VIRTUAL_TIME
      notificationStore.setVirtualTime(action.time, action.notifications)
    when ActionTypes.PLAY_VIRTUAL_TIME
      notificationStore.setVirtualTime(0, action.notifications)
      notificationStore.startTimer(action.notifications, 0)

module.exports = notificationStore
