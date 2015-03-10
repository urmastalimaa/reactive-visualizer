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

  componentWillUpdate: (nextProps, nextState) ->
    nextState.slider.val nextProps.value

  componentWillUnmount: ->
    @state.slider.off 'slide', @handleSlide

  componentDidMount: ->
    toolTip = if @props.toolTip then 'show' else 'hide'
    slider = $(@getDOMNode()).slider
      id: @props.id
      min: @props.min
      max: @props.max
      step: @props.step
      value: @props.value
      tooltip: toolTip
    slider.on 'slide', @handleSlide
    @setState slider: slider
  render: ->
    <div style={@props.style}/>
)

Visualizer.ReactNodes.Slider = Slider
