V = Visualizer
N = V.ReactNodes


setVirtualTime = V.setVirtualTime
capturedNotificationStore = V.capturedNotificationStore

TimeSlider = React.createClass(

  getInitialState: ->
    notifications: {}
    sliderSettings:
      time: @props.initialTime
      min: @props.initialMin
      max: @props.initialMax
      initialValue: @props.initialValue

  handleSliderChange: (sliderValue) ->
    setVirtualTime(sliderValue, @state.notifications)

  handleNotifications: ->
    notifications = capturedNotificationStore.getNotifications()
    @setState notifications: notifications

  componentDidMount: ->
    capturedNotificationStore.addChangeListener @handleNotifications

  componentWillUnmount: ->
    capturedNotificationStore.removeChangeListener @handleNotifications

  render: ->
    sliderSettings = @state.sliderSettings
    # rework this
    setTimeout =>
      @handleSliderChange(sliderSettings.initialValue)
    <N.Slider id="time_slider"
      min={sliderSettings.min}
      max={sliderSettings.max}
      step=1
      value={sliderSettings.initialValue}
      style={width: "100%"}
      onSlide={@handleSliderChange}
    />
)

Visualizer.ReactNodes.TimeSlider = TimeSlider
