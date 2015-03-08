BuildArea = React.createClass
  getInitialState: ->
    observable: @props.defaultObservable

  handleChange: (observable) ->
    @setState observable: observable
    @props.onChange observable

  render: ->
    <div className="buildArea">
      <Observable observable={@state.observable} id='' ref="observable" recursionLevel=0 onChange={@handleChange}/>
      <button className="start" id="start">Start</button>
      <div>
        <button className="persistency" id="save">Save</button>
        <button className="persistency" id="load">Load</button>
        <button className="persistency" id="clear">Clear</button>
      </div>
    </div>

Visualizer.BuildArea = BuildArea
