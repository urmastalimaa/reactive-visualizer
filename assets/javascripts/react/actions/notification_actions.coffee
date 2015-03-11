V = Visualizer
Dispatcher = V.Dispatcher

V.setNotifications = (notifications) ->
  Dispatcher.dispatch
    type: 'receive_notifications'
    notifications: notifications

V.setVirtualTime = (time, notifications) ->
  Dispatcher.dispatch
    type: 'receive_virtual_time'
    time: time
    notifications: notifications

