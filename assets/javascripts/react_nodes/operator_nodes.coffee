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

createSimpleObservable = R.curryN 2, (rootType, rootArgs) ->
  root:
    type: rootType
    args: rootArgs
  operators: []

getClosedOverArgName = (recursionLevel) ->
  'outerValue' + (recursionLevel && recursionLevel + 1 || '')

recursiveFunctionOperators =
  flatMap:
    recursive: true
    recursionType: 'function'
    defaultArgs: "function(outerValue) {"
    getDefaultObservable: R.compose(createSimpleObservable('just'), getClosedOverArgName)

recursiveOperators =
  merge:
    recursive: true
    recursionType: 'observable'
    getDefaultObservable: R.always(createSimpleObservable('just')('1,2'))
  amb:
    recursive: true
    recursionType: 'observable'
    getDefaultObservable: R.always
      root:
        type: 'of'
      operators: [
        { type: 'delay', args: '1000' }
      ]

createSimpleOperator = (defaultArgs) ->
  React.createClass
    render: ->
      <N.Helpers.InputArea defaultValue={@props.args || defaultArgs}/>

RecursiveOperator = React.createClass
  handleChange: (observable) ->
    @setState observable: observable
    @props.onChildOperatorChange(observable)

  getInitialState: ->
    observable: @props.observable

  render: ->
    root = <Observable id={@props.id} observable={@state.observable} recursionLevel={@props.recursionLevel + 1} onChange={@handleChange} />
    <span className="recursiveContainer" style={paddingLeft: '50px'} >
      {@props.children}
      {root}
      {'}'}
    </span>

createRecursiveFunctionOperator = ->
  React.createClass
    render: ->
      definition = @props.args || "function(#{getClosedOverArgName(@props.recursionLevel)}) { return "
      <RecursiveOperator id={@props.id} observable={@props.observable} recursionLevel={@props.recursionLevel} onChildOperatorChange={@props.onChildOperatorChange}>
        <span className="functionDeclaration" id={@props.id}>
          <N.Helpers.InputArea defaultValue={definition} />
        </span>
      </RecursiveOperator>

operatorClasses = [
  R.mapObj(R.compose(createSimpleOperator, R.get('defaultArgs')))(simpleOperators)
  R.mapObj(createRecursiveFunctionOperator)(recursiveFunctionOperators)
  R.mapObj(R.always(RecursiveOperator))(recursiveOperators)
]


OperatorClasses = R.foldl(R.mixin, {}, operatorClasses)

N.ObservableOperator = React.createClass
  handleRemove: ->
    @props.onRemove(@props.operator)

  handleChildObservableChange: (observable) ->
    @props.onChildOperatorChange(@props.operator, observable)

  render: ->
    opEl = React.createElement(OperatorClasses[@props.operator.type], R.mixin(@props.operator,
      onChildOperatorChange: @handleChildObservableChange, recursionLevel: @props.recursionLevel
    ))

    <div className={@props.operator.type} id={@props.operator.id} style={width: '100%'}>
      {".#{@props.operator.type}("} {opEl} {')'}
      {@props.children}
      <RemoveOperator onRemove={@handleRemove}/>
      <N.SimulationArea />
    </div>

RemoveOperator = React.createClass
  handleClick: ->
    @props.onRemove()
  render: ->
    <button className='remove' onClick={@handleClick}>-</button>

N.Operators = R.foldl(R.mixin, {}, [simpleOperators
  recursiveOperators
  recursiveFunctionOperators
])
