V = Visualizer
Dispatcher = V.Dispatcher

ActionTypes =
  RECEIVE_NOTIFICATIONS: 'receive_notifications'
  RECEIVE_VIRTUAL_TIME: 'receive_virtual_time'
  PLAY_VIRTUAL_TIME: 'play_virtual_time'

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

  timeCounts = R.compose(
    R.foldl((acc, countedTimes) ->
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


  createFiller = (time) ->
    time: time
    value: {kind: 'filler'}

  takeLast = R.curryN 2, (count, vals) ->
    end = R.length(vals)
    start = Math.max(0, end - MAX_NR_OF_RELEVANT_TIMES)
    R.slice(start, end)(vals)

  fillOnTime = R.curryN 3, (notificationsByTime, maxCount, time) ->
    notsByTime = notificationsByTime[time] || []
    repeated = R.repeat(createFiller(time), maxCount - notsByTime.length)
    R.concat(repeated, notsByTime)


  fillNotificationOnTime = R.curryN 1, (notificationsByTime) ->
    R.compose(
      R.flatten
      R.values
      R.mapObjIndexed(fillOnTime(notificationsByTime))
    )

  fillAllNotifications: (notifications) ->
    countedTimes = timeCounts(notifications)
    R.mapObj((notificationsByKey) ->
      byTime = R.groupBy(R.get('time'))(notificationsByKey)
      fillNotificationOnTime(byTime)(countedTimes)
    )(notifications)

  filterRelevant: R.curryN 1, (currentTime) ->
    R.mapObj(R.compose(
      takeLast(6)
      R.filter(
        R.compose(
          R.gte(currentTime)
          R.get('time')
        )
      )
    ))

  init: (notifications, currentTime) ->
    _notifications = notifications
    _filledNotifications = @fillAllNotifications(notifications)
    _relevantNotifications = @filterRelevant(currentTime)(_filledNotifications)
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

V.notificationStore = new NotificationStore

V.notificationStore.dispatchToken = Dispatcher.register (action) ->
  switch action.type
    when ActionTypes.RECEIVE_VIRTUAL_TIME
      V.notificationStore.setVirtualTime(action.time, action.notifications)
    when ActionTypes.PLAY_VIRTUAL_TIME
      V.notificationStore.setVirtualTime(action.time, action.notifications)
      V.notificationStore.startTimer(action.notifications, action.time)

