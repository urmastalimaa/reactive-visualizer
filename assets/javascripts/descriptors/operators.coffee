R = require 'ramda'
argTypes = require './argument_types'

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

alwaysValues = ->
  R.always(Array.prototype.slice.call(arguments))
singleValueType = [argTypes.VALUE]
singleFunctionType = [argTypes.FUNCTION]
alwaysEmpty = R.always([])

simpleOperators = R.mapObj(R.merge(simpleOperatorsDefaults))(
  average:
    getDefaultArgs: alwaysValues('function(x) { return x; }')
    argTypes: singleFunctionType
  bufferWithCount:
    getDefaultArgs: alwaysValues("2")
    argTypes: singleValueType
  bufferWithTime:
    getDefaultArgs: alwaysValues('1000')
    argTypes: singleValueType
    useScheduler: true
  bufferWithTimeOrCount:
    getDefaultArgs: alwaysValues('1000', '3')
    argTypes: [argTypes.VALUE, argTypes.VALUE]
    useScheduler: true
  concatAll:
    argTypes: []
    getDefaultArgs: alwaysEmpty
  count:
    argTypes: []
    getDefaultArgs: alwaysEmpty
  debounce:
    getDefaultArgs: alwaysValues('1000')
    argTypes: singleValueType
    useScheduler: true
  defaultIfEmpty:
    argTypes: singleValueType
    getDefaultArgs: alwaysValues("'defaultValue'")
  delay:
    getDefaultArgs: alwaysValues('1000')
    argTypes: singleValueType
    useScheduler: true
  distinct:
    argTypes: singleFunctionType
    getDefaultArgs: alwaysValues("function(x) { return x % 2 }")
  distinctUntilChanged:
    argTypes: singleFunctionType
    getDefaultArgs: alwaysValues("function(x) { return x % 2 }")
  elementAt:
    getDefaultArgs: alwaysValues('1')
    argTypes: singleValueType
  elementAtOrDefault:
    getDefaultArgs: alwaysValues('1', "'defaultValue'")
    argTypes: [argTypes.VALUE, argTypes.VALUE]
  every:
    getDefaultArgs: alwaysValues("function(x) { return x % 2 == 0 }")
    argTypes: singleFunctionType
  find:
    getDefaultArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  first:
    getDefaultArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  firstOrDefault:
    getDefaultArgs: alwaysValues(defaultFunc("return value < 20;"), "'defaultValue'")
    argTypes: [argTypes.FUNCTION, argTypes.VALUE]
  filter:
    getDefaultArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  groupBy:
    getDefaultArgs: alwaysValues(defaultFunc("return value % 2"), defaultFunc("return value;"))
    argTypes: [argTypes.FUNCTION, argTypes.FUNCTION]
  includes:
    getDefaultArgs: alwaysValues("5")
    argTypes: singleValueType
  ignoreElements:
    getDefaultArgs: alwaysEmpty
    argTypes: []
  indexOf:
    getDefaultArgs: alwaysValues("5")
    argTypes: singleValueType
  isEmpty:
    getDefaultArgs: alwaysEmpty
    argTypes: []
  last:
    getDefaultArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  lastOrDefault:
    getDefaultArgs: alwaysValues(defaultFunc("return value < 20;"), 'defaultValue')
    argTypes: singleFunctionType
  map:
    getDefaultArgs: alwaysValues(defaultFunc("return value * value;"))
    argTypes: singleFunctionType
  max:
    getDefaultArgs: alwaysValues(defaultFunc("return value;"))
    argTypes: singleFunctionType
  mergeAll:
    getDefaultArgs: alwaysEmpty
    argTypes: []
  min:
    getDefaultArgs: alwaysValues(defaultFunc("return value;"))
    argTypes: singleFunctionType
  pairwise:
    getDefaultArgs: alwaysEmpty
    argTypes: []
  pluck:
    getDefaultArgs: alwaysValues("'property'")
    argTypes: singleValueType
  reduce:
    getDefaultArgs: alwaysValues("function(acc, x) { return acc * x; }", '1')
    argTypes: singleFunctionType
  repeat:
    getDefaultArgs: alwaysValues("2")
    argTypes: singleValueType
  retry:
    getDefaultArgs: alwaysValues("3")
    argTypes: singleValueType
  sample:
    getDefaultArgs: alwaysValues("500")
    argTypes: singleValueType
    useScheduler: true
  scan:
    getDefaultArgs: alwaysValues('1',"function(acc, x) { return acc * x; }")
    argTypes: [argTypes.VALUE, argTypes.FUNCTION]
  single:
    getDefaultArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  singleOrDefault:
    getDefaultArgs: alwaysValues(defaultFunc("return value < 20;"), "'defaultValue'")
    argTypes: [argTypes.FUNCTION, argTypes.VALUE]
  skip:
    getDefaultArgs: alwaysValues("5")
    argTypes: singleValueType
  skipLast:
    getDefaultArgs: alwaysValues("3")
    argTypes: singleValueType
  skipLastWithTime:
    getDefaultArgs: alwaysValues("1000")
    argTypes: singleValueType
    useScheduler: true
  skipUntilWithTime:
    getDefaultArgs: alwaysValues("2000")
    argTypes: singleValueType
    useScheduler: true
  startWith:
    getDefaultArgs: alwaysValues("1, 2, 3")
    argTypes: singleValueType
  some:
    getDefaultArgs: alwaysValues(defaultFunc("return value > 10;"))
    argTypes: singleFunctionType
  sum:
    getDefaultArgs: alwaysValues("function(x, idx) { return x; }")
    argTypes: singleFunctionType
  take:
    getDefaultArgs: alwaysValues("4")
    argTypes: singleValueType
  takeLast:
    getDefaultArgs: alwaysValues("4")
    argTypes: singleValueType
  takeLastBuffer:
    getDefaultArgs: alwaysValues("4")
    argTypes: singleValueType
  takeLastBufferWithTime:
    useScheduler: true
    getDefaultArgs: alwaysValues("2000")
    argTypes: singleValueType
  takeLastWithTime:
    useScheduler: true
    getDefaultArgs: alwaysValues("2000")
    argTypes: singleValueType
  takeUntilWithTime:
    useScheduler: true
    getDefaultArgs: alwaysValues("5000")
    argTypes: singleValueType
  takeWhile:
    getDefaultArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  timeInterval:
    getDefaultArgs: alwaysEmpty
    argTypes: []
    useScheduler: true
  throttleFirst:
    getDefaultArgs: alwaysValues("1000")
    argTypes: singleValueType
    useScheduler: true
  timeout:
    getDefaultArgs: alwaysValues("1000")
    argTypes: singleValueType
    useScheduler: true
  timestamp:
    getDefaultArgs: alwaysEmpty
    argTypes: []
    useScheduler: true
  toArray:
    getDefaultArgs: alwaysEmpty
    argTypes: []
  windowWithCount:
    getDefaultArgs: alwaysValues("2")
    argTypes: singleValueType
  windowWithTime:
    getDefaultArgs: alwaysValues("1000")
    argTypes: singleValueType
    useScheduler: true
  windowWithTimeOrCount:
    getDefaultArgs: alwaysValues("1000", "3")
    useScheduler: true
)

getReturningFunctionWithClosedOver = R.compose(getReturningFunctionDeclaration, getClosedOverArgName)

wrapInArray = (val) ->
  [val]

recursiveFunctionOperatorsDefaults =
  recursive: true
  recursionType: 'function'
  argTypes: [argTypes.RECURSIVE_FUNCTION]
  getDefaultArgs: getReturningFunctionWithClosedOver
  getDefaultObservable: R.compose(createSimpleObservable('just'), wrapInArray,  getClosedOverArgName)

recursiveFunctionOperators = R.mapObj(R.merge(recursiveFunctionOperatorsDefaults))(
  flatMap: {}
  flatMapLatest: {}
  delayWithSelector:
    getDefaultObservable: R.compose(createSimpleObservable('timer'), wrapInArray, R.add("1000 * "), getClosedOverArgName)
  buffer:
    getDefaultObservable: R.compose(createSimpleObservable('timer'), alwaysValues("1000"))
  concatMap:
    getDefaultObservable: R.compose(createSimpleObservable('range'), ((closedOverArg) -> ["0", closedOverArg]), getClosedOverArgName)
  debounceWithSelector:
    getDefaultObservable: R.compose(createSimpleObservable('timer'), wrapInArray, getClosedOverArgName)
  expand:
    getDefaultObservable: R.compose(createSimpleObservable('just'), wrapInArray, ((arg) -> "#{arg} + #{arg}" ), getClosedOverArgName)
  timeoutWithSelector:
    getDefaultObservable: R.compose(createSimpleObservable('timer'), wrapInArray, ((arg) -> "#{arg} * 100"), getClosedOverArgName)
  window:
    getDefaultObservable: R.compose(createSimpleObservable('timer'), alwaysValues("1000"))
)

recursiveOperatorDefaults =
  recursive: true
  recursionType: 'observable'
  argTypes: [argTypes.OBSERVABLE]

recursiveOperators = R.mapObj(R.merge(recursiveOperatorDefaults))(
  merge:
    getDefaultObservable: R.always(createSimpleObservable('of')(['1,2']))
  amb:
    getDefaultObservable: R.always
      root:
        type: 'of'
      operators: [
        { type: 'delay', args: ['1000'] }
      ]
  concat:
    getDefaultObservable: R.always(createSimpleObservable('just')(['5']))
  sequenceEqual:
    getDefaultObservable: R.always(createSimpleObservable('just')(['5']))
  skipUntil:
    getDefaultObservable: R.always(createSimpleObservable('timer')(['1000']))
  takeUntil:
    getDefaultObservable: R.always(createSimpleObservable('timer')(['1000']))
)

recursiveOperatorsWithTrailingArgsDefaults =
  recursive: true
  recursionType: 'observableWithSelector'
  getDefaultObservable: R.always(createSimpleObservable('of')(['1,2']))
  getDefaultArgs: alwaysValues(simpleCombinerFunction)
  argTypes: [argTypes.OBSERVABLE, argTypes.FUNCTION]

recursiveOperatorsWithTrailingArgs = R.mapObj(R.merge(recursiveOperatorsWithTrailingArgsDefaults))(
  combineLatest: {}
  withLatestFrom: {}
  zip: {}
)

sortByKeys = R.compose(R.fromPairs, R.sortBy(R.nthArg(0)), R.toPairs)

module.exports = sortByKeys(R.reduce(R.merge, {}, [simpleOperators
  recursiveOperators
  recursiveFunctionOperators
  recursiveOperatorsWithTrailingArgs
]))
