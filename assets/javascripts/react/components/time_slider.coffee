V = Visualizer
N = V.ReactNodes


setVirtualTime = V.setVirtualTime
capturedNotificationStore = V.capturedNotificationStore

TimeSlider = React.createClass(

  getInitialState: ->
    notifications: {}

  handleSliderChange: (sliderValue) ->
    setVirtualTime(sliderValue, @state.notifications)

  getUniqueTimes: (notifications) ->
    R.compose(R.uniq, R.map(R.get('time')), R.flatten, R.values)(notifications)

  handleNotifications: ->
    notifications = capturedNotificationStore.getNotifications()

    @setState notifications: notifications

  componentDidMount: ->
    capturedNotificationStore.addChangeListener @handleNotifications

  componentWillUnmount: ->
    capturedNotificationStore.removeChangeListener @handleNotifications

  render: ->
    uniqueTimes = @getUniqueTimes(@state.notifications)

    min = switch tryMin = R.min(uniqueTimes)
      when Infinity then @props.initialMin
      else tryMin
    max = switch tryMax = R.max(uniqueTimes)
      when -Infinity then @props.initialMax
      else tryMax

    <N.Slider id="time_slider"
      min={min}
      max={max}
      step=1
      value={@props.initialValue}
      style={width: "100%"}
      onChange={@handleSliderChange}
    />
)

Visualizer.ReactNodes.TimeSlider = TimeSlider
