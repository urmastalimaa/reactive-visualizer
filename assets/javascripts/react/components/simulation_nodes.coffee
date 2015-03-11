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
      <SimulationValueArea values={@state.notifications}/>
    </span>

SimulationValueArea = React.createClass

  joinValues: R.compose(R.join(', '), R.pluck('value'), R.pluck('value'))

  render: ->
    <span> {@joinValues(@props.values)} </span>
