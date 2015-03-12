R = require 'ramda'
Rs = require 'react-bootstrap'
React = require 'react'
NotificationStore = require '../stores/notification_store'

module.exports = React.createClass
  getInitialState: ->
    timeCounts: []
  onNotificationsChange: ->
    @setState(timeCounts: NotificationStore.getCurrentTimeCounts())

  componentDidMount: ->
    NotificationStore.addChangeListener(@onNotificationsChange)

  componentWillUnmount: ->
    NotificationStore.removeChangeListener(@onNotificationsChange)

  render: ->
    timeCols = R.mapObjIndexed( (count, time) ->
      <div key={"time" + time} className="simulationTimeWrapper" style={minWidth: "#{count * 84}px"}>
        <div className="simulationValue">
          {time}
        </div>
      </div>
    )(@state.timeCounts)
    <div id="simulation-header" style={width: '100%', display: 'inline-block'}>
      <span style={float: 'right'}>
        {timeCols}
      </span>
    </div>

