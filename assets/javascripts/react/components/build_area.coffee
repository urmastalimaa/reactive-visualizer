V = Visualizer
N = V.ReactNodes

BuildArea = React.createClass
  getInitialState: ->
    observable: V.identifyStructure(@props.defaultObservable)

  handleChange: (observable) ->
    identifiedObservable = V.identifyStructure(observable)
    @setState observable: identifiedObservable
    @props.onChange identifiedObservable

  handleSliderChange: (sliderValue) ->
    console.log "slider value", sliderValue

  render: ->
    <div className="buildArea" style={@props.style}>
      <N.Observable observable={@state.observable} id='' ref="observable" recursionLevel=0 onChange={@handleChange} rowLength={@props.rowLength}/>
      <button className="start" id="start">Start</button>
      <div>
        <button className="persistency" id="save">Save</button>
        <button className="persistency" id="load">Load</button>
        <button className="persistency" id="clear">Clear</button>
      </div>
      <N.Slider id="ja" min=0 max=1000 step=1 value=300 style={width: "100%"} onSlide={@handleSliderChange}/>
    </div width='inherit'>

N.BuildArea = BuildArea
