V = Visualizer
N = V.ReactNodes
notificationStore = V.notificationStore
Rs = ReactBootstrap

N.SimulationArea = React.createClass

  getInitialState: ->
    notifications: []

  onNotificationsChange: ->
    @setState(notifications: notificationStore.getCurrentNotifications(@props.id))

  componentDidMount: ->
    notificationStore.addChangeListener(@onNotificationsChange)

  componentWillUnmount: ->
    notificationStore.removeChangeListener(@onNotificationsChange)

  render: ->
    <span className="simulationArea" style={float: 'right'} >
      <SimulationValueArea values={@state.notifications} id={@props.id}/>
    </span>

SimulationValueArea = React.createClass
  completeColumn: ({time, value}, index) ->
    <Rs.Col xs={1} className='simulation-complete' key={@props.id + index}>
      {'C'}
    </Rs.Col>

  valueColumn: ({time, value}, index, arr) ->
    <Rs.Col xs={1} className='simulation-value' key={@props.id + index} style={opacity: (1 / arr.length) * (index + 1)}>
      {value.value}
    </Rs.Col>

  errorColumn: ({time, value}, index) ->
    <Rs.Col xs={1} className='simulation-error' key={@props.id + index}>
      {value.exception || 'Error'}
    </Rs.Col>

  emptyColumn: ({time, value}, index) ->
    <Rs.Col xs={1} className='simulation-filler' key={@props.id + index} />

  mapNotification: (notification, index, list) ->
    switch notification.value.kind
      when 'N'
        @valueColumn(notification, index, list)
      when 'E'
        @errorColumn(notification, index, list)
      when 'C'
        @completeColumn(notification, index, list)
      when 'filler'
        @emptyColumn(notification, index, list)

  render: ->
    <Rs.Row style={width: 300}>
      {R.mapIndexed(@mapNotification, @props.values)}
    </Rs.Row>