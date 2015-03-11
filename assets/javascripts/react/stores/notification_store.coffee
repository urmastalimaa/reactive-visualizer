V = Visualizer
Dispatcher = V.Dispatcher

ActionTypes =
  RECEIVE_NOTIFICATIONS: 'receive_notifications'
  RECEIVE_VIRTUAL_TIME: 'receive_virtual_time'

class NotificationStore extends V.BaseStore

  MAX_NR_OF_RELEVANT_TIMES = 6

  _relevantNotifications = {}
  _notifications = {}

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
    _notifications = notifications
    _relevantNotifications = mapInRelevantTimes(relevantTimes(startTimes))(notifications)

    @emitChange()

  startTimer: (notifications, startTimes) ->
    _disposable = new Rx.SerialDisposable
    startTime = R.last(startTimes) || 0
    earliestTime = earliestTimeAfter(startTime)(notifications)
    if (earliestTime != Infinity)
      _disposable.setDisposable(
        Rx.Observable.timer(earliestTime - startTime)
          .subscribe =>
            @init(notifications, R.append(earliestTime, startTimes))
            @startTimer(notifications, R.append(earliestTime, startTimes))
      )

  setVirtualTime: (time, notifications) ->
    _disposable.dispose()
    startTimes = R.uniq(R.map(R.get('time'),  R.flatten(R.values(notifications))))
    relTimes = R.filter(R.gte(time))(startTimes)
    @init(notifications, relTimes)
    @startTimer(notifications, relTimes)

  getCurrentNotifications: (id) ->
    _relevantNotifications[id] || []

V.notificationStore = new NotificationStore

V.notificationStore.dispatchToken = Dispatcher.register (action) ->
  switch action.type
    when ActionTypes.RECEIVE_VIRTUAL_TIME
      V.notificationStore.setVirtualTime(action.time, action.notifications)

