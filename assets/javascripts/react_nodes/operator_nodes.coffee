V = Visualizer
N = Visualizer.ReactNodes

defaultFunc = (impl) ->
  "function(value) { #{impl} }"

createSimpleObservable = R.curryN 2, (rootType, rootArgs) ->
  root:
    type: rootType
    args: rootArgs
  operators: []

getClosedOverArgName = (recursionLevel) ->
  'outerValue' + (recursionLevel && recursionLevel + 1 || '')

simpleOperators =
  map:
    getDefaultArgs: R.always(defaultFunc("return value * value;"))
    useScheduler: false
  take:
    getDefaultArgs: R.always("4")
    useScheduler: true
  filter:
    getDefaultArgs: R.always(defaultFunc("return value < 20;"))
    useScheduler: false
  delay:
    getDefaultArgs: R.always("1000")
    useScheduler: true
  bufferWithTime:
    getDefaultArgs: R.always("1000")
    useScheduler: true

recursiveFunctionOperators =
  flatMap:
    recursive: true
    recursionType: 'function'
    getDefaultArgs: R.always("function(outerValue) {")
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

SimpleOperator = React.createClass
  render: ->
    <N.Helpers.InputArea defaultValue={@props.args}/>

RecursiveOperator = React.createClass
  render: ->
    <span className="recursiveContainer" style={paddingLeft: '50px'} >
      <V.Observable id={@props.id} observable={@props.observable} recursionLevel={@props.recursionLevel + 1} onChange={@props.onChildOperatorChange} />
    </span>

RecursionFunctionOperator = React.createClass
  render: ->
    <span className="recusiveFunctionOperator">
      <span className="functionDeclaration" id={@props.id}>
        <N.Helpers.InputArea defaultValue={@props.args} />
      </span>
      <RecursiveOperator id={@props.id} observable={@props.observable} recursionLevel={@props.recursionLevel} onChildOperatorChange={@props.onChildOperatorChange}>
      </RecursiveOperator>
      {'}'}
    </span>


operatorClasses = [
  R.mapObj(R.always(SimpleOperator))(simpleOperators)
  R.mapObj(R.always(RecursionFunctionOperator))(recursiveFunctionOperators)
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
