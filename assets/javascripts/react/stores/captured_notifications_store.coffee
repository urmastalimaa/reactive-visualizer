Dispatcher = require '../dispatcher/dispatcher'
BaseStore = require './base_store'

ActionTypes =
  RECEIVE_NOTIFICATIONS: 'receive_notifications'

class CapturedNotificationStore extends BaseStore

  _notifications = null

  init: (notifications) ->
    _notifications = notifications
    @emitChange(notifications)

  getNotifications: (id) ->
    if id
      _notifications[id]
    else
      _notifications

capturedNotificationStore = new CapturedNotificationStore

capturedNotificationStore.dispatchToken = Dispatcher.register (action) ->
  switch action.type
    when ActionTypes.RECEIVE_NOTIFICATIONS
      capturedNotificationStore.init(action.notifications)

module.exports = capturedNotificationStore
