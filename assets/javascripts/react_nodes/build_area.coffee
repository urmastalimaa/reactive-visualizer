BuildArea = React.createClass
  getInitialState: ->
    observable: @props.defaultObservable

  handleChange: (observable) ->
    @setState observable: observable
    @props.onChange observable

  render: ->
    <div className="buildArea">
      <Observable observable={@state.observable} ref="observable" recursionLevel=0 onChange={@handleChange}/>
      <button className="start" id="start">Start</button>
      <button className="save" id="save">Save</button>
    </div>

Visualizer.BuildArea = BuildArea
