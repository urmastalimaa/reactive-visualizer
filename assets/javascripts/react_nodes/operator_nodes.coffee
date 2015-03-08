V = Visualizer
N = Visualizer.ReactNodes

defaultFunc = (impl) ->
  "function(value) { #{impl} }"

simpleOperators =
  map:
    defaultArgs: defaultFunc("return value * value;")
    useScheduler: false
  take:
    defaultArgs: "4"
    useScheduler: true
  filter:
    defaultArgs: defaultFunc("return value < 20;")
    useScheduler: false
  delay:
    defaultArgs: "1000"
    useScheduler: true
  bufferWithTime:
    defaultArgs: "1000"
    useScheduler: true

recursiveFunctionOperators =
  flatMap:
    defaultArgs: "function(outerValue) {"
    recursive: true

recursiveOperators =
  merge:
    recursive: true
  amb:
    recursive: true

createSimpleOperator = (defaultArgs) ->
  React.createClass
    render: ->
      <N.Helpers.InputArea defaultValue={@props.args || defaultArgs}/>

createRecursiveFunctionOperator = ->
  React.createClass
    handleChange: (observable) ->
      @setState observable: observable
      @props.onChildOperatorChange(observable, 'function')

    getClosedOverArgName: ->
      if @props.recursionLevel == 0
        'outerValue'
      else
        'outerValue' + (@props.recursionLevel + 1)

    getInitialState: ->
      defaultObservable =
        root:
          type: 'of'
          id: @props.id + "r"
          args: @getClosedOverArgName()
        operators: []
      observable: @props.observable || defaultObservable

    render: ->
      # this is bad, but need to trigger change somehow, don't know where else to initialize the observable
      unless @props.observable
        setTimeout =>
          @handleChange(@state.observable)

      definition = @props.args || "function(#{@getClosedOverArgName()}) { return "
      root = <Observable id={@props.id + "r"} observable={@state.observable} ref="observable", recursionLevel={@props.recursionLevel + 1} onChange={@handleChange} />
      <span className="recursiveContainer" style={paddingLeft: '50px'} >
        <span className="functionDeclaration" id={@props.id}>
          <N.Helpers.InputArea defaultValue={definition} />
        </span>
        {root}
        {'}'}
      </span>

createRecursiveOperator = ->
  React.createClass
    handleChange: (observable) ->
      @setState observable: observable
      @props.onChildOperatorChange(observable, 'observable')

    getInitialState: ->
      defaultObservable =
        root:
          type: 'of'
          id: @props.id + "r"
        operators: []
      observable: @props.observable || defaultObservable

    render: ->
      # this is bad, but need to trigger change somehow, don't know where else to initialize the observable
      unless @props.observable
        setTimeout =>
          @handleChange(@state.observable)

      root = <Observable id={@props.id + "r"} observable={@state.observable} ref="observable", recursionLevel={@props.recursionLevel + 1} onChange={@handleChange} />
      <span className="recursiveContainer" style={paddingLeft: '50px'} >
        {root}
        {'}'}
      </span>

operatorClasses = [
  R.mapObj(R.compose(createSimpleOperator, R.get('defaultArgs')))(simpleOperators)
  R.mapObj(createRecursiveFunctionOperator)(recursiveFunctionOperators)
  R.mapObj(createRecursiveOperator)(recursiveOperators)
]

N.Operators = R.foldl(R.mixin, {}, [simpleOperators
  recursiveOperators
  recursiveFunctionOperators
])

N.OperatorClasses = R.foldl(R.mixin, {}, operatorClasses)

