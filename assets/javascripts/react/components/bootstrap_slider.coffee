React = require 'react'
BoostrapSlider = require 'bootstrap-slider'

Slider = React.createClass(
  getDefaultProps: ->
    {
      min: 0
      max: 100
      step: 1
      value: 50
      toolTip: false
      onChange: ->
    }

  handleChange: ({oldValue, newValue}) ->
    @props.onChange(newValue)

  componentWillUpdate: (nextProps, nextState) ->
    nextState.slider
      .setValue nextProps.value
      .setAttribute 'min', Math.max(0, nextProps.min - 100)
      .setAttribute 'max', nextProps.max + 100

  componentWillUnmount: ->
    @state.slider.destroy()

  componentDidMount: ->
    toolTip = if @props.toolTip then 'show' else 'hide'
    slider = new BoostrapSlider @getDOMNode(),
      id: @props.id
      min: @props.min
      max: @props.max
      step: @props.step
      value: @props.value
      tooltip: toolTip

    slider.on 'change', @handleChange
    @setState slider: slider

  render: ->
    <div style={@props.style}/>
)

module.exports = Slider
