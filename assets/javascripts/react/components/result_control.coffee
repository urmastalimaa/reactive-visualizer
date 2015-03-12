React = require 'react'
R = require 'ramda'

TimeSlider = require './time_slider'

NotificationActions = require '../actions/notification_actions'
CapturedNotificationStore = require '../stores/captured_notifications_store'

buildObservable    = require '../../builder/builder'
evaluateObservable = require '../../factory/factory'
simulateObservable = require '../../simulator/simulator'

getNotifications = R.compose(
  simulateObservable
  evaluateObservable
  buildObservable
)

module.exports = React.createClass
  analyze: ->
    notifications = getNotifications(@props.observable)
    NotificationActions.setNotifications(notifications)

  play: ->
    notifications = CapturedNotificationStore.getNotifications()
    NotificationActions.playVirtualTime(notifications)

  render: ->
    <div>
      <button className="analyze" id="analyze" onClick={@analyze}>Analyze</button>
      <button className="play" id="play" onClick={@play}>Play</button>
      <TimeSlider initialTime={0} initialMin={0} initialMax={3000} initialValue={0} />
    </div>
