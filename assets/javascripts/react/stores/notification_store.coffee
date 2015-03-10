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

class V.NotificationStore extends StoreEmitter

  getNotifications: (id) ->
    []

V.NotificationStore.dispatchToken = V.Dispatcher.register (action) ->
  switch action.type
    when ActionTypes.RECEIVE_NOTIFICATIONS
      NotificationStore.init(action.notifications)
      NotificationStore.emitChange()
