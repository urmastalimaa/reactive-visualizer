V = Visualizer

BuildArea = React.createClass
  getInitialState: ->
    observable: V.identifyStructure(@props.defaultObservable)

  handleChange: (observable) ->
    identifiedObservable = V.identifyStructure(V.evaluateInput(observable))
    @setState observable: identifiedObservable
    @props.onChange identifiedObservable

  render: ->
    <div className="buildArea">
      <V.Observable observable={@state.observable} id='' ref="observable" recursionLevel=0 onChange={@handleChange}/>
      <button className="start" id="start">Start</button>
      <div>
        <button className="persistency" id="save">Save</button>
        <button className="persistency" id="load">Load</button>
        <button className="persistency" id="clear">Clear</button>
      </div>
    </div>

V.BuildArea = BuildArea
