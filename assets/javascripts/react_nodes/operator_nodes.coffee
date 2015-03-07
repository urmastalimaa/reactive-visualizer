V = Visualizer
N = Visualizer.ReactNodes
O = N.Operators = {}

defaultFunc = (impl) ->
  "function(value) { #{impl} }"

O.map = React.createClass
  render: ->
    args = @props.args || defaultFunc("return value * value;")
    <N.Helpers.TextArea defaultValue={args}/>

O.take = React.createClass
  render: ->
    args = @props.args || "4"
    <N.Helpers.VarargsArea defaultValue={args}/>

O.filter = React.createClass
  render: ->
    args = @props.args || defaultFunc("return value < 20;")
    <N.Helpers.TextArea defaultValue={args}/>

O.delay = React.createClass
  render: ->
    args = @props.args || "100"
    <N.Helpers.VarargsArea defaultValue={args} />

O.bufferWithTime = React.createClass
  render: ->
    args = @props.args || "1000"
    <N.Helpers.VarargsArea defaultValue={args}/>

createRecursiveOperator = (defaultFunctionDeclaration) ->
  React.createClass
    handleChange: (observable) ->
      @setState observable: observable
      @props.onChildOperatorChange(observable)

    getClosedOverArgName: ->
      if @props.recursionLevel == 0
        'outerValue'
      else
        'outerValue' + (@props.recursionLevel + 1)

    getInitialState: ->
      defaultObservable =
        root:
          id: @props.id + "r"
          type: 'of'
          args: @getClosedOverArgName()
        operators: []
      observable: @props.observable || defaultObservable

    render: ->
      setTimeout =>
        @props.onChildOperatorChange(@state.observable)

      definition = @props.args || "function(#{@getClosedOverArgName()}) { return "
      root = <Observable observable={@state.observable} ref="observable", recursionLevel={@props.recursionLevel + 1} onChange={@handleChange} />
      <span className="recursiveContainer" style={paddingLeft: '50px'} >
        <span className="functionDeclaration">
          <N.Helpers.FunctionDeclaration defaultValue={definition} />
        </span>
        {root}
        {'}'}
      </span>

O.flatMap = createRecursiveOperator()

