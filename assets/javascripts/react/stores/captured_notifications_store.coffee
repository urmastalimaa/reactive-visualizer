V = Visualizer
Dispatcher = V.Dispatcher

ActionTypes =
  RECEIVE_NOTIFICATIONS: 'receive_notifications'

class CapturedNotificationStore extends V.BaseStore

  _notifications = null

  init: (notifications) ->
    _notifications = notifications
    @emitChange(notifications)

  getNotifications: (id) ->
    if id
      _notifications[id]
    else
      _notifications

V.capturedNotificationStore = new CapturedNotificationStore

V.capturedNotificationStore.dispatchToken = Dispatcher.register (action) ->
  switch action.type
    when ActionTypes.RECEIVE_NOTIFICATIONS
      V.capturedNotificationStore.init(action.notifications)
