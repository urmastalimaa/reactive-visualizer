V = Visualizer
Dispatcher = V.Dispatcher

ActionTypes =
  RECEIVE_NOTIFICATIONS: 'receive_notifications'

class StoreEmitter extends EventEmitter
  CHANGE_EVENT = 'change'

  emitChange: ->
    @emit(CHANGE_EVENT)

  addChangeListener: (callback) ->
    @on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @removeListener(CHANGE_EVENT, callback)


class NotificationStore extends StoreEmitter

  MAX_NR_OF_RELEVANT_TIMES = 6

  _relevantNotifications = {}

  _disposable = new Rx.SerialDisposable

  earliestTimeAfter = (startTime) ->
    R.compose(
      R.min
      R.filter(R.lt(startTime))
      R.pluck('time')
      R.flatten
      R.values
    )

  fillNotifications = R.curryN 2, (times, notifications) ->
    R.flatten(R.map((time) ->
      onTime = R.filter(R.propEq('time', time))(notifications)
      if onTime.length == 0
        [{ time: time, value: {kind: 'filler'} }]
      else
        onTime
    )(times))

  mapInRelevantTimes = (times) ->
    R.mapObj(fillNotifications(times))

  relevantTimes = (times) ->
    end = times.length
    start = Math.max(0, end - MAX_NR_OF_RELEVANT_TIMES)
    R.slice(start, end, times)

  init: (notifications, startTimes) ->
    startTime = R.last(startTimes)
    _relevantNotifications = mapInRelevantTimes(relevantTimes(startTimes))(notifications)

    earliestTime = earliestTimeAfter(startTime)(notifications)
    if (earliestTime != Infinity)
      _disposable.setDisposable(
        Rx.Observable.timer(earliestTime - startTime)
          .subscribe =>
            @init(notifications, R.append(earliestTime, startTimes))
      )

    @emitChange()

  getNotifications: (id) ->
    _relevantNotifications[id]


V.notificationStore = new NotificationStore

V.notificationStore.dispatchToken = Dispatcher.register (action) ->
  switch action.type
    when ActionTypes.RECEIVE_NOTIFICATIONS
      V.notificationStore.init(action.notifications, [0])
