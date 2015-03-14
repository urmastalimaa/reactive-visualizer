React = require 'react'
R = require 'ramda'

TimeSlider = require './time_slider'

NotificationStore = require '../stores/notification_store'
ReactBootstrap = require 'react-bootstrap'
{Alert, Button, ButtonToolbar} = ReactBootstrap

buildObservable    = require '../../builder/builder'
evaluateObservable = require '../../factory/factory'
simulateObservable = require '../../simulator/simulator'

getNotifications = R.compose(
  simulateObservable
  evaluateObservable
  buildObservable
)

ANALYZE_ERROR = "
  Sorry! Your observable is built incorrectly.
  Check the usage of your operators.
"

module.exports = React.createClass

  getInitialState: ->
    notifications: {}
    time: 0

  componentWillUpdate: ->
    @hideAnalyzeError() if @state.notifications.error

  handleTimeChange: (time) ->
    if @state.time != time
      NotificationStore.setVirtualTime(time, @state.notifications)
      @setState time: time

  hideAnalyzeError: ->
    @showInErrorArea(<span />)

  showAnalyzeError: ->
    @showInErrorArea(<Alert bsStyle="warning"> {ANALYZE_ERROR} </Alert>)

  showInErrorArea: (component)->
    React.render(component, @refs.analyzeError.getDOMNode())

  analyze: ->
    notifications = getNotifications(@props.observable)
    if !notifications.error
      @handleNewNotifications(notifications)
    else
      @showAnalyzeError()
      @handleNewNotifications(notifications)

  handleNewNotifications: (notifications) ->
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
    showReplayArea = R.keys(@state.notifications).length > 0 && !@state.notifications.error

    replayArea = [
      <Button key="play" className="play" id="play" onClick={@play} bsStyle="success" style={marginBottom: '5px'}>Play</Button>
      <TimeSlider key="slider" notifications={@state.notifications} handleChange={@handleTimeChange} value={@state.time} />
    ]

    <ButtonToolbar>
      <Button className="analyze" id="analyze" onClick={@analyze} bsStyle="success" style={marginBottom: '5px'}>
      Analyze
        <div id="analyzeError" ref="analyzeError" />
      </Button>
      { if showReplayArea then replayArea }
    </ButtonToolbar>
