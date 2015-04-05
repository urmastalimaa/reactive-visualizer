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
    times = R.keys(@state.timeCounts)
    timeCols = R.mapObjIndexed( (count, time) ->
      index = R.findIndex(R.eq(time))(times)
      opacity = ( 1 / times.length) * (index + 1)

      <div key={"time" + time} className="simulationTimeWrapper" style={minWidth: "#{count * 84}px", opacity: opacity}>

        <div className="simulationValue">
          {time}
        </div>
      </div>
    )(@state.timeCounts)

    <div id="simulation-header" className="simulationHeader">
      <span className="simulationArea">
        {R.values(timeCols)}
      </span>
    </div>

