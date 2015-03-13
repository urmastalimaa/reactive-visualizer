React = require 'react'
BoostrapSlider = require 'bootstrap-slider'

Slider = React.createClass(
  getDefaultProps: ->
    {
      min: 0
      max: 100
      step: 1
      value: 50
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
      id: @props.id
      min: @props.min
      max: @props.max
      step: @props.step
      value: @props.value
      tooltip: @props.toolTip

    slider.on 'change', @handleChange
    @setState slider: slider

  render: ->
    <div style={@props.style}/>
)

module.exports = Slider
