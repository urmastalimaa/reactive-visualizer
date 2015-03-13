React = require 'react'
R = require 'ramda'

TimeSlider = require './time_slider'

NotificationStore = require '../stores/notification_store'

buildObservable    = require '../../builder/builder'
evaluateObservable = require '../../factory/factory'
simulateObservable = require '../../simulator/simulator'

getNotifications = R.compose(
  simulateObservable
  evaluateObservable
  buildObservable
)

module.exports = React.createClass

  getInitialState: ->
    notifications: {}
    time: 0

  handleTimeChange: (time) ->
    if @state.time != time
      NotificationStore.setVirtualTime(time, @state.notifications)
      @setState time: time

  analyze: ->
    notifications = getNotifications(@props.observable)
    NotificationStore.setVirtualTime(0, notifications)

    @setState notifications: notifications
    @setState time: 0

  componentWillReceiveProps: (nextProps) ->
    unless R.eq(@props.observable, nextProps.observable)
      @setState notifications: {}

  play: ->
    timeCallback = (time) =>
      @setState time: time
    NotificationStore.play @state.notifications, @state.time, timeCallback

  render: ->
    showReplayArea = R.keys(@state.notifications).length > 0

    replayArea =
      <div id="replayArea">
        <button className="play" id="play" onClick={@play}>Play</button>
        <TimeSlider notifications={@state.notifications} handleChange={@handleTimeChange} value={@state.time} />
      </div>

    <div>
      <button className="analyze" id="analyze" onClick={@analyze}>Analyze</button>
      { if showReplayArea then replayArea }
    </div>
