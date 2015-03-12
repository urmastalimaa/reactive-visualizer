V = Visualizer
N = V.ReactNodes
Rs = ReactBootstrap
notificationStore = V.notificationStore

N.SimulationHeader = React.createClass
  getInitialState: ->
    timeCounts: []
  onNotificationsChange: ->
    @setState(timeCounts: notificationStore.getCurrentTimeCounts())

  componentDidMount: ->
    notificationStore.addChangeListener(@onNotificationsChange)

  componentWillUnmount: ->
    notificationStore.removeChangeListener(@onNotificationsChange)

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

