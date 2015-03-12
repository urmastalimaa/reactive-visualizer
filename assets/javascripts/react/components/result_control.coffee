React = require 'react'
R = require 'ramda'

TimeSlider = require './time_slider'

NotificationActions = require '../actions/notification_actions'

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
    NotificationActions.setVirtualTime(time, @state.notifications)
    @setState time: time

  analyze: ->
    notifications = getNotifications(@props.observable)
    @setState notifications: notifications

  componentWillReceiveProps: (nextProps) ->
    unless R.eq(@props.observable, nextProps.observable)
      @setState notifications: {}

  play: ->
    @setState time: 0
    NotificationActions.playVirtualTime(@state.notifications)

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
