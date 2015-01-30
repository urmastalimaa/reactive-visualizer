BuildArea = React.createClass
  getInitialState: ->
    observable: @props.defaultObservable

  handleChange: (observable) ->
    @setState observable: observable
    @props.onChange observable

  render: ->
    <div className="buildArea">
      <Observable observable={@state.observable} ref="observable" onChange={@handleChange}/>
      <button className="start" id="start">Start</button>
    </div>

window.BuildArea = BuildArea
