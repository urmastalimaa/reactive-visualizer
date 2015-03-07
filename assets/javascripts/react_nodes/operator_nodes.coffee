V = Visualizer
N = Visualizer.ReactNodes

defaultFunc = (impl) ->
  "function(value) { #{impl} }"

simpleOperators =
  map:
    defaultArgs: defaultFunc("return value * value;")
  take:
    defaultArgs: "4"
  filter:
    defaultArgs: defaultFunc("return value < 20;")
  delay:
    defaultArgs: "1000"
  bufferWithTime:
    defaultArgs: "1000"

recursiveOperators =
  flatMap: ''

createSimpleOperator = (defaultArgs) ->
  React.createClass
    render: ->
      <N.Helpers.InputArea defaultValue={@props.args || defaultArgs}/>

createRecursiveOperator = ->
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
          type: 'of'
          args: @getClosedOverArgName()
        operators: []
      observable: @props.observable || defaultObservable

    render: ->
      definition = @props.args || "function(#{@getClosedOverArgName()}) { return "
      root = <Observable id={@props.id + "r"} observable={@state.observable} ref="observable", recursionLevel={@props.recursionLevel + 1} onChange={@handleChange} />
      <span className="recursiveContainer" style={paddingLeft: '50px'} >
        <span className="functionDeclaration">
          <N.Helpers.InputArea defaultValue={definition} />
        </span>
        {root}
        {'}'}
      </span>

simpleOperatorClasses = R.mapObj(R.compose(createSimpleOperator, R.get('defaultArgs')))(simpleOperators)
recursiveOperatorClasses = R.mapObj(createRecursiveOperator)(recursiveOperators)

N.Operators = R.mixin simpleOperatorClasses, recursiveOperatorClasses

