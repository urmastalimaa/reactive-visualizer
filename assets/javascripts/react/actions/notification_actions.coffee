Dispatcher = require '../dispatcher/dispatcher'

module.exports =

setNotifications: (notifications) ->
  Dispatcher.dispatch
    type: 'receive_notifications'
    notifications: notifications

setVirtualTime: (time, notifications) ->
  Dispatcher.dispatch
    type: 'receive_virtual_time'
    time: time
    notifications: notifications

playVirtualTime: (notifications) ->
  Dispatcher.dispatch
    type: 'play_virtual_time'
    notifications: notifications
