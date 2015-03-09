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

simpleOperatorsDefaults = useScheduler: false, recursionType: 'none'
simpleOperators = R.mapObj(R.mixin(simpleOperatorsDefaults))(
  average:
    getDefaultArgs: R.always("function(x) { return x; }")
  bufferWithCount:
    getDefaultArgs: R.always("2")
  bufferWithTime:
    getDefaultArgs: R.always("1000")
    useScheduler: true
  bufferWithTimeOrCount:
    getDefaultArgs: R.always("1000", 3)
    useScheduler: true
  concatAll: {}
  count: {}
  debounce:
    getDefaultArgs: R.always("1000")
    useScheduler: true
  defaultIfEmpty:
    getDefaultArgs: R.always("'defaultValue'")
  delay:
    getDefaultArgs: R.always("1000")
    useScheduler: true
  distinct:
    getDefaultArgs: R.always("function(x) { return x % 2 }")
  distinctUntilChanged:
    getDefaultArgs: R.always("function(x) { return x % 2 }")
  elementAt:
    getDefaultArgs: R.always("1")
  elementAtOrDefault:
    getDefaultArgs: R.always("1, 'defaultValue'")
  every:
    getDefaultArgs: R.always("function(x) { return x % 2 == 0 }")
  find:
    getDefaultArgs: R.always(defaultFunc("return value < 20;"))
  first:
    getDefaultArgs: R.always(defaultFunc("return value < 20;"))
  firstOrDefault:
    getDefaultArgs: R.always(defaultFunc("return value < 20;") + ", 'defaultValue'")
  filter:
    getDefaultArgs: R.always(defaultFunc("return value < 20;"))
  groupBy:
    getDefaultArgs: R.always(defaultFunc("return value % 2") + "," + defaultFunc("return value;"))
  includes:
    getDefaultArgs: R.always("5")
  ignoreElements: {}
  indexOf:
    getDefaultArgs: R.always("5")
  isEmpty: {}
  last:
    getDefaultArgs: R.always(defaultFunc("return value < 20;"))
  lastOrDefault:
    getDefaultArgs: R.always(defaultFunc("return value < 20;") + ", 'defaultValue'")
  map:
    getDefaultArgs: R.always(defaultFunc("return value * value;"))
  max:
    getDefaultArgs: R.always(defaultFunc("return value;"))
  mergeAll: {}
  min:
    getDefaultArgs: R.always(defaultFunc("return value;"))
  pairwise: {}
  pluck:
    getDefaultArgs: R.always("'property'")
  reduce:
    getDefaultArgs: R.always("function(acc, x) { return acc * x; }, 1")
  repeat:
    getDefaultArgs: R.always("2")
  retry:
    getDefaultArgs: R.always("3")
  sample:
    getDefaultArgs: R.always("500")
    useScheduler: true
  scan:
    getDefaultArgs: R.always("1, function(acc, x) { return acc * x; }")
  single:
    getDefaultArgs: R.always(defaultFunc("return value < 20;"))
  singleOrDefault:
    getDefaultArgs: R.always(defaultFunc("return value < 20;") + ", 'defaultValue'")
  skip:
    getDefaultArgs: R.always("5")
  skipLast:
    getDefaultArgs: R.always("3")
  skipLastWithTime:
    useScheduler: true
    getDefaultArgs: R.always("1000")
  skipUntilWithTime:
    useScheduler: true
    getDefaultArgs: R.always("2000")
  startWith:
    getDefaultArgs: R.always("1, 2, 3")
  some:
    getDefaultArgs: R.always(defaultFunc("return value > 10;"))
  sum:
    getDefaultArgs: R.always("function(x, idx) { return x; }")
  take:
    getDefaultArgs: R.always("4")
  takeLast:
    getDefaultArgs: R.always("4")
  takeLastBuffer:
    getDefaultArgs: R.always("4")
  takeLastBufferWithTime:
    useScheduler: true
    getDefaultArgs: R.always("2000")
  takeLastWithTime:
    useScheduler: true
    getDefaultArgs: R.always("2000")
  takeUntilWithTime:
    useScheduler: true
    getDefaultArgs: R.always("5000")
  takeWhile:
    getDefaultArgs: R.always(defaultFunc("return value < 20;"))
  timeInterval:
    useScheduler: true
  throttleFirst:
    getDefaultArgs: R.always("1000")
    useScheduler: true
  timeout:
    getDefaultArgs: R.always("1000")
    useScheduler: true
  timestamp:
    useScheduler: true
  toArray: {}
  windowWithCount:
    getDefaultArgs: R.always("2")
  windowWithTime:
    getDefaultArgs: R.always("1000")
    useScheduler: true
  windowWithTimeOrCount:
    getDefaultArgs: R.always("1000", 3)
    useScheduler: true
)

getReturningFunctionWithClosedOver = R.compose(getReturningFunctionDeclaration, getClosedOverArgName)

recursiveFunctionOperatorsDefaults =
  recursive: true
  recursionType: 'function'
  getDefaultArgs: getReturningFunctionWithClosedOver
  getDefaultObservable: R.compose(createSimpleObservable('just'), getClosedOverArgName)
recursiveFunctionOperators = R.mapObj(R.mixin(recursiveFunctionOperatorsDefaults))(
  flatMap: {}
  flatMapLatest: {}
  buffer:
    getDefaultObservable: R.compose(createSimpleObservable('timer'), R.always("1000"))
  concatMap:
    getDefaultObservable: R.compose(createSimpleObservable('range'), ((closedOverArg) -> "0, #{closedOverArg}"), getClosedOverArgName)
  debounceWithSelector:
    getDefaultObservable: R.compose(createSimpleObservable('timer'), getClosedOverArgName)
  expand:
    getDefaultObservable: R.compose(createSimpleObservable('just'), ((arg) -> "#{arg} + #{arg}" ), getClosedOverArgName)
  timeoutWithSelector:
    getDefaultObservable: R.compose(createSimpleObservable('timer'), ((arg) -> "#{arg} * 100"), getClosedOverArgName)
  window:
    getDefaultObservable: R.compose(createSimpleObservable('timer'), R.always("1000"))
)

recursiveOperatorDefaults =
  recursive: true
  recursionType: 'observable'
recursiveOperators = R.mapObj(R.mixin(recursiveOperatorDefaults))(
  merge:
    getDefaultObservable: R.always(createSimpleObservable('just')('1,2'))
  amb:
    getDefaultObservable: R.always
      root:
        type: 'of'
      operators: [
        { type: 'delay', args: '1000' }
      ]
  concat:
    getDefaultObservable: R.always(createSimpleObservable('just')('5'))
  sequenceEqual:
    getDefaultObservable: R.always(createSimpleObservable('just')('5'))
  skipUntil:
    getDefaultObservable: R.always(createSimpleObservable('timer')('1000'))
  takeUntil:
    getDefaultObservable: R.always(createSimpleObservable('timer')('1000'))
)

recursiveOperatorsWithTrailingArgsDefaults =
  recursive: true
  recursionType: 'observableWithSelector'
  getDefaultObservable: R.always(createSimpleObservable('just')('1,2'))
  getDefaultArgs: R.always(simpleCombinerFunction)
recursiveOperatorsWithTrailingArgs = R.mapObj(R.mixin(recursiveOperatorsWithTrailingArgsDefaults))(
  combineLatest: {}
  withLatestFrom: {}
  zip: {}
)

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


N.Operators = R.foldl(R.mixin, {}, [simpleOperators
  recursiveOperators
  recursiveFunctionOperators
  recursiveOperatorsWithTrailingArgs
])

OperatorClasses = R.mapObject( ({recursionType}) ->
  switch recursionType
  when 'none' then SimpleOperator
  when 'function' then RecursionFunctionOperator
  when 'observable' then RecursiveOperator
  when 'observableWithSelector' then RecursiveOperatorWithTrailingArgs
)

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

