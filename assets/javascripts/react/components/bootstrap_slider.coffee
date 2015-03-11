V = Visualizer
setVirtualTime = V.setVirtualTime
notificationStore = V.notificationStore

Slider = React.createClass(
  getDefaultProps: ->
    {
      min: 0
      max: 100
      step: 1
      value: 50
      toolTip: false
      onSlide: ->
    }

  handleSlide: (event) ->
    @props.onSlide event.value
    setVirtualTime(event.value, @state.notifications)

  handleNotifications: ->
    notifications = notificationStore.getAllNotifications()
    @setState notifications: notifications

  componentWillUpdate: (nextProps, nextState) ->
    nextState.slider.val nextProps.value

  componentWillUnmount: ->
    @state.slider.off 'slide', @handleSlide
    notificationStore.removeChangeListener @handleNotifications

  componentDidMount: ->
    toolTip = if @props.toolTip then 'show' else 'hide'
    slider = $(@getDOMNode()).slider
      id: @props.id
      min: @props.min
      max: 5000
      step: @props.step
      value: @props.value
      tooltip: toolTip
    notificationStore.addChangeListener @handleNotifications

    slider.on 'slide', @handleSlide
    @setState slider: slider

  render: ->
    <div style={@props.style}/>
)

Visualizer.ReactNodes.Slider = Slider
