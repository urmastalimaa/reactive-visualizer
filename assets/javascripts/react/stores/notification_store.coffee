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

  TOO_OLD_THRESHOLD = 5 * 1000

  _relevantNotifications = []

  _disposable = new Rx.SerialDisposable

  earliestTimeAfter = (startTime) ->
    R.compose(
      R.min
      R.filter(R.lt(startTime))
      R.pluck('time')
      R.flatten
      R.values
    )

  between = R.useWith(R.and, R.lte, R.gte)

  inRelevantTimerange = (startTime) ->
    between(startTime - TOO_OLD_THRESHOLD, startTime)

  mapInRelevantTime = (time) ->
    R.mapObj R.filter(R.compose(inRelevantTimerange(time), R.get('time')))

  init: (notifications, startTime) ->
    _relevantNotifications = mapInRelevantTime(startTime)(notifications)

    earliestTime = earliestTimeAfter(startTime)(notifications)
    if (earliestTime != Infinity)
      _disposable.setDisposable(
        Rx.Observable.timer(earliestTime - startTime)
          .subscribe =>
            @init(notifications, earliestTime)
      )

    @emitChange()

  getNotifications: (id) ->
    _relevantNotifications[id]

V.notificationStore = new NotificationStore

V.notificationStore.dispatchToken = Dispatcher.register (action) ->
  switch action.type
    when ActionTypes.RECEIVE_NOTIFICATIONS
      V.notificationStore.init(action.notifications, 0)
