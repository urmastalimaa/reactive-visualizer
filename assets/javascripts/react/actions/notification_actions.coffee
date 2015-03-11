V = Visualizer
Dispatcher = V.Dispatcher

V.setNotifications = (notifications) ->
  Dispatcher.dispatch
    type: 'receive_notifications'
    notifications: notifications

