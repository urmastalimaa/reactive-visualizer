V = Visualizer
N = Visualizer.ReactNodes
O = N.Operators = {}

defaultFunc = (impl) ->
  "function(value) { #{impl} }"

O.map = React.createClass
  render: ->
    <N.Helpers.TextArea defaultValue={defaultFunc("return value * value;")}/>

O.filter = React.createClass
  render: ->
    <N.Helpers.TextArea defaultValue={defaultFunc("return value < 20;")}/>

O.delay = React.createClass
  render: ->
    <N.Helpers.VarargsArea defaultValue="100" />

O.bufferWithTime = React.createClass
  render: ->
    <N.Helpers.VarargsArea defaultValue="1000" />

O.flatMap = React.createClass
  handleChange: (observable) ->
    @setState observable: observable
    @props.onChildOperatorChange(observable)

  getInitialState: ->
    observable:
      root: { type: 'of', id: @props.id + "r" }
      operators: []

  render: ->
    # There should be a better way to update the initial root
    setTimeout =>
      @props.onChildOperatorChange(@state.observable)

    root = <Observable observable={@state.observable} ref="observable", onChange={@handleChange} />
    <span className="recursiveContainer" style={paddingLeft: '50px'} >
      <span className="functionDeclaration">
        <N.Helpers.FunctionDeclaration defaultValue={'function(value) {'} />
      </span>
      {root}
      {'}'}
    </span>

