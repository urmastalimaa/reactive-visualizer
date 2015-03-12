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
      <N.SimulationHeader />
      <N.Observable observable={@state.observable} id='' ref="observable" recursionLevel=0 onChange={@handleChange} rowLength={@props.rowLength}/>
      <button className="analyze" id="analyze">Analyze</button>
      <button className="play" id="play">Play</button>
      <div>
        <button className="persistency" id="save">Save</button>
        <button className="persistency" id="load">Load</button>
        <button className="persistency" id="clear">Clear</button>
      </div>
      <N.TimeSlider initialTime={0} initialMin={0} initialMax={3000} initialValue={0}/>
    </div width='inherit'>

N.BuildArea = BuildArea
