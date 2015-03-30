React = require 'react'
BoostrapSlider = require 'bootstrap-slider'
R = require 'ramda'

Slider = React.createClass(
  getDefaultProps: ->
    {
      min: 0
      max: 1000
      step: 1
      value: 500
      toolTip: true
      onChange: ->
    }

  handleChange: ({oldValue, newValue}) ->
    @props.onChange(newValue)

  componentWillUpdate: (nextProps, nextState) ->
    nextState.slider
      .setValue nextProps.value
      .setAttribute 'min', nextProps.min
      .setAttribute 'max', nextProps.max

  componentWillUnmount: ->
    @state.slider.destroy()

  componentDidMount: ->
    slider = new BoostrapSlider @getDOMNode(),
      R.pick(['id', 'min', 'max', 'step', 'value', 'tooltip'])(@props)
    slider.on 'change', @handleChange
    @setState slider: slider

  render: ->
    <div id={@props.id} style={@props.style}/>
)

module.exports = Slider
