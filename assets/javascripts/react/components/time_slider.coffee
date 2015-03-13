R = require 'ramda'
React = require 'react'
Slider = require '../components/bootstrap_slider'

getUniqueTimes =  (notifications) ->
  R.compose(R.uniq, R.map(R.get('time')), R.flatten, R.values)(notifications)

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

    <Slider id="time_slider"
      min={Math.max(min - 100, 0)}
      max={max + 100}
      step=1
      value={@props.value}
      style={width: "100%"}
      onChange={@handleSliderChange}
    />
)

module.exports = TimeSlider
