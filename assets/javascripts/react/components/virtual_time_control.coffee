React = require 'react'
R = require 'ramda'

TimeSlider = require './time_slider'

NotificationStore = require '../stores/notification_store'
{Alert, Button, ButtonToolbar} = require 'react-bootstrap'

build    = require '../../builder'
inspect  = require '../../inspection_wrapper'
simulate = require '../../simulator'

getNotifications = R.compose(
  simulate
  inspect
  build
)

ANALYZE_ERROR = "
  Sorry! Your observable is built incorrectly.
  Check the usage of your operators.
"

module.exports = React.createClass

  getInitialState: ->
    notifications: {}
    time: 0
    playing: false

  handleTimeChange: (time) ->
    if @state.time != time
      @setState time: time, playing: false

  hideAnalyzeError: ->
    @showInErrorArea(<span />)

  showAnalyzeError: ->
    @showInErrorArea(<Alert bsStyle="warning"> {ANALYZE_ERROR} </Alert>)

  showInErrorArea: (component)->
    React.render(component, @refs.analyzeError.getDOMNode())

  componentWillReceiveProps: (nextProps) ->
    unless R.eq(@props.observable, nextProps.observable)
      @setState notifications: getNotifications(nextProps.observable)

  componentWillUpdate: (nextProps, nextState) ->
    @hideAnalyzeError() if @state.notifications.error
    @showAnalyzeError() if nextState.notifications.error

    unless nextState.playing
      # could optimize somewhat to filter out pointless time changes
      NotificationStore.setVirtualTime(nextState.time, nextState.notifications)

  componentDidMount: ->
    # force componentWillUpdate
    @setState notifications: getNotifications(@props.observable)

  play: ->
    playCallback = (time) =>
      @setState time: time, playing: true
    NotificationStore.play @state.notifications, @state.time, playCallback

  render: ->
    showReplayArea = R.keys(@state.notifications).length > 0 && !@state.notifications.error

    replayArea = [
      <TimeSlider key="slider" notifications={@state.notifications} handleChange={@handleTimeChange} value={@state.time} />
      <Button key="play" className="play" id="play" onClick={@play} bsStyle="success" style={marginBottom: '5px'}>Play</Button>
    ]

    <div id="virtualTimeControl">
      <div id="analyzeError" ref="analyzeError" />
      { if showReplayArea then replayArea }
    </div>
