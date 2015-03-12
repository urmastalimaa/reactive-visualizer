R = require 'ramda'
React = require 'react'
NotificationActions = require '../actions/notification_actions'
CapturedNotificationStore = require '../stores/captured_notifications_store'
Slider = require '../components/bootstrap_slider'

TimeSlider = React.createClass(

  getInitialState: ->
    notifications: {}

  handleSliderChange: (sliderValue) ->
    NotificationActions
      .setVirtualTime(sliderValue, @state.notifications)

  getUniqueTimes: (notifications) ->
    R.compose(R.uniq, R.map(R.get('time')), R.flatten, R.values)(notifications)

  handleNotifications: ->
    notifications = CapturedNotificationStore.getNotifications()

    @setState notifications: notifications

  componentDidMount: ->
    CapturedNotificationStore.addChangeListener @handleNotifications

  componentWillUnmount: ->
    CapturedNotificationStore.removeChangeListener @handleNotifications

  render: ->
    uniqueTimes = @getUniqueTimes(@state.notifications)

    min = switch tryMin = R.min(uniqueTimes)
      when Infinity then @props.initialMin
      else tryMin
    max = switch tryMax = R.max(uniqueTimes)
      when -Infinity then @props.initialMax
      else tryMax

    <Slider id="time_slider"
      min={min}
      max={max}
      step=1
      value={@props.initialValue}
      style={width: "100%"}
      onChange={@handleSliderChange}
    />
)

module.exports = TimeSlider
