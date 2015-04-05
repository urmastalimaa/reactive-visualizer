R = require 'ramda'
React = require 'react'
Slider = require '../components/bootstrap_slider'

getUniqueTimes =  (notifications) ->
  R.compose(R.uniq, R.map(R.prop('time')), R.flatten, R.values)(notifications)

TimeSlider = React.createClass(

  handleSliderChange: (sliderValue) ->
    @props.handleChange(sliderValue)

  getMinAndMax: (times) ->
    min = switch tryMin = R.min(times)
      when Infinity then 0
      else tryMin
    max = switch tryMax = R.max(times)
      when -Infinity then 1000
      else tryMax
    [min, max]

  render: ->
    [min, max] = @getMinAndMax(getUniqueTimes(@props.notifications))

    <Slider id="timeSlider"
      min={Math.round(min * 0.1)}
      max={Math.round(max * 1.00)}
      step=1
      value={@props.value}
      style={width: "100%"}
      onChange={@handleSliderChange}
    />
)

module.exports = TimeSlider
