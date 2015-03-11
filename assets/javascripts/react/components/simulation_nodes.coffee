V = Visualizer
N = V.ReactNodes
notificationStore = V.notificationStore

N.SimulationArea = React.createClass

  getInitialState: ->
    notifications: []

  onNotificationsChange: ->
    @setState(notifications: notificationStore.getNotifications(@props.id))

  componentDidMount: ->
    notificationStore.addChangeListener(@onNotificationsChange)

  componentWillUnmount: ->
    notificationStore.removeChangeListener(@onNotificationsChange)

  render: ->
    <span className="simulationArea" style={float: 'right'} >
      <SimulationValueArea value={@state.notifications}/>
    </span>

SimulationValueArea = React.createClass

  joinValues: R.compose(R.join(', '), R.pluck('value'), R.pluck('value'))

  render: ->
    values = @props.value
    if values.length == 0
      <span>{'No value yet'}</span>
    else if values.length == 1
      <span>
        {'Value:'}<span className="value">{values[0].value.value}</span>
      </span>
    else
      <span>{'Values!'}{@joinValues(values)}</span>
