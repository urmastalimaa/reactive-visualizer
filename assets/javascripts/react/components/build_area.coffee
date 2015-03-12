React = require 'react'
R = require 'ramda'
identifyStructure = require '../../builder/structure_identifier'
SimulationHeader = require './simulation_header'
Observable = require './observable'
TimeSlider = require './time_slider'
PersistencyArea = require './persistency'

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

BuildArea = React.createClass
  analyze: ->
    notifications = getNotifications(@state.observable)
    NotificationActions.setNotifications(notifications)

  play: ->
    notifications = CapturedNotificationStore.getNotifications()
    NotificationActions.playVirtualTime(notifications)

  getInitialState: ->
    observable: identifyStructure(@props.defaultObservable)

  handleChange: (observable) ->
    identifiedObservable = identifyStructure(observable)
    @setState observable: identifiedObservable

  render: ->
    <div className="buildArea" style={@props.style}>
      <SimulationHeader />
      <Observable observable={@state.observable} id='' ref="observable" recursionLevel=0 onChange={@handleChange} rowLength={@props.rowLength}/>
      <PersistencyArea defaultObservable={@props.defaultObservable}
        observable={@state.observable} onChange={@handleChange} />
      <button className="analyze" id="analyze" onClick={@analyze}>Analyze</button>
      <button className="play" id="play" onClick={@play}>Play</button>
      <TimeSlider initialTime={0} initialMin={0} initialMax={3000} initialValue={0}/>
    </div>

module.exports = BuildArea
