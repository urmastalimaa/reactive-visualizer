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

simpleCombinerFunction = 'function(first, second){ return {first: first, second: second}; }'

getReturningFunctionDeclaration = (args) ->
  "function(#{args}) { return "

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
    getDefaultArgs: R.compose(getReturningFunctionDeclaration, getClosedOverArgName)
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

recursiveOperatorsWithTrailingArgs =
  combineLatest:
    recursive: true
    recursionType: 'observableWithSelector'
    getDefaultObservable: R.always(createSimpleObservable('just')('1,2'))
    getDefaultArgs: R.always(simpleCombinerFunction)

SimpleOperator = React.createClass
  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    if N.Operators[@props.operator.type].getDefaultArgs
      <N.Helpers.InputArea value={@props.operator.args} id={@props.operator.id} onChange={@onArgsChange} />
    else
      false

RecursiveOperator = React.createClass
  render: ->
    <span className="recursiveContainer" style={paddingLeft: '50px'} >
      <V.Observable id={@props.operator.id} observable={@props.operator.observable} recursionLevel={@props.recursionLevel + 1} onChange={@props.onChildOperatorChange} />
    </span>

RecursionFunctionOperator = React.createClass
  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    <span className="recusiveFunctionOperator">
      <span className="functionDeclaration" id={@props.operator.id}>
        <N.Helpers.InputArea value={@props.operator.args} onChange={@onArgsChange}/>
      </span>
      <RecursiveOperator operator={@props.operator} recursionLevel={@props.recursionLevel} onChildOperatorChange={@props.onChildOperatorChange} onChange={@props.onChange}/>
      {'}'}
    </span>

RecursiveOperatorWithTrailingArgs = React.createClass
  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    <span>
      <RecursiveOperator operator={@props.operator} recursionLevel={@props.recursionLevel} onChildOperatorChange={@props.onChildOperatorChange} onChange={@props.onChange}/>
      ,
      <span className="recursiveOperatorTrailingArg" id={@props.operator.id}>
        <N.Helpers.InputArea value={@props.operator.args} onChange={@onArgsChange} />
      </span>
    </span>


operatorClasses = [
  R.mapObj(R.always(SimpleOperator))(simpleOperators)
  R.mapObj(R.always(RecursionFunctionOperator))(recursiveFunctionOperators)
  R.mapObj(R.always(RecursiveOperator))(recursiveOperators)
  R.mapObj(R.always(RecursiveOperatorWithTrailingArgs))(recursiveOperatorsWithTrailingArgs)
]

OperatorClasses = R.foldl(R.mixin, {}, operatorClasses)

N.ObservableOperator = React.createClass
  handleRemove: ->
    @props.onRemove(@props.operator)

  handleChildObservableChange: (observable) ->
    @props.onChildOperatorChange(@props.operator, observable)

  onChange: (operator) ->
    @props.onChange(operator)

  render: ->

    args = {
      operator: @props.operator
      onChildOperatorChange: @handleChildObservableChange
      recursionLevel: @props.recursionLevel
      onChange: @onChange
    }
    opEl = React.createElement(OperatorClasses[@props.operator.type], args)

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
  recursiveOperatorsWithTrailingArgs
])
