R = require 'ramda'
React = require 'react'
NotificationStore = require '../stores/notification_store'

module.exports = React.createClass

  getInitialState: ->
    notifications: []

  onNotificationsChange: ->
    @setState(notifications: NotificationStore.getCurrentNotifications(@props.id))

  componentDidMount: ->
    NotificationStore.addChangeListener(@onNotificationsChange)

  componentWillUnmount: ->
    NotificationStore.removeChangeListener(@onNotificationsChange)

  render: ->
    <span className="simulationArea" style={float: 'right'} >
      <SimulationValueArea values={@state.notifications} id={@props.id}/>
    </span>

SimulationValueArea = React.createClass
  completeColumn: ({time, value}, id) ->
    <div key={id} className="simulationValue">
      {'C'}
    </div>

  valueColumn: ({time, value}, id) ->
    <div key={id} className="simulationValue">
      {JSON.stringify(value.value)}
    </div>

  errorColumn: ({time, value}, id) ->
    <div key={id} className="simulationValue">
      {value.exception || 'Error'}
    </div>

  childColumn: (notification, id) ->
    switch notification.value.kind
      when 'N'
        @valueColumn(notification, id)
      when 'E'
        @errorColumn(notification, id)
      when 'C'
        @completeColumn(notification, id)

  timeColumn: ({values, count}, time, obj) ->
    id = @props.id
    childCols = R.mapIndexed( (notification, index) =>
        @childColumn(notification, id + index)
    )(values)
    keys = R.keys(obj)
    index = R.indexOf(time)(keys)
    opacity = ( 1 / keys.length) * (index + 1)

    width = "#{count * 84}px"

    <div className="simulationTimeWrapper" style={opacity: opacity, minWidth:width, width: width} key={id + time} >
      {childCols}
    </div>

  render: ->
    <div key={@props.id} className="simulationArea">
      {R.values(R.mapObjIndexed(@timeColumn, @props.values))}
    </div>
