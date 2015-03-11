V = Visualizer

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

  handleChange: (event) ->
    {oldValue, newValue} = event.value
    @props.onChange(newValue)

  componentWillUpdate: (nextProps, nextState) ->
    nextState.slider
      .slider('setValue', nextProps.value)
      .slider('setAttribute', 'min', Math.max(0, nextProps.min - 100))
      .slider('setAttribute', 'max', nextProps.max + 100)

  componentWillUnmount: ->
    @state.slider.off 'change', @handleChange

  componentDidMount: ->
    toolTip = if @props.toolTip then 'show' else 'hide'
    slider = $(@getDOMNode()).slider
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

Visualizer.ReactNodes.Slider = Slider
