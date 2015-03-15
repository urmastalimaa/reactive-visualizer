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
    getArgs: alwaysValues('function(x) { return x; }')
    argTypes: singleFunctionType
  bufferWithCount:
    getArgs: alwaysValues("2")
    argTypes: singleValueType
  bufferWithTime:
    getArgs: alwaysValues('1000')
    argTypes: singleValueType
    useScheduler: true
  bufferWithTimeOrCount:
    getArgs: alwaysValues('1000', '3')
    argTypes: [argTypes.VALUE, argTypes.VALUE]
    useScheduler: true
  concatAll:
    argTypes: []
    getArgs: alwaysEmpty
  count:
    argTypes: []
    getArgs: alwaysEmpty
  debounce:
    getArgs: alwaysValues('1000')
    argTypes: singleValueType
    useScheduler: true
  defaultIfEmpty:
    argTypes: singleValueType
    getArgs: alwaysValues("'defaultValue'")
  delay:
    getArgs: alwaysValues('1000')
    argTypes: singleValueType
    useScheduler: true
  distinct:
    argTypes: singleFunctionType
    getArgs: alwaysValues("function(x) { return x % 2 }")
  distinctUntilChanged:
    argTypes: singleFunctionType
    getArgs: alwaysValues("function(x) { return x % 2 }")
  elementAt:
    getArgs: alwaysValues('1')
    argTypes: singleValueType
  elementAtOrDefault:
    getArgs: alwaysValues('1', "'defaultValue'")
    argTypes: [argTypes.VALUE, argTypes.VALUE]
  every:
    getArgs: alwaysValues("function(x) { return x % 2 == 0 }")
    argTypes: singleFunctionType
  find:
    getArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  first:
    getArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  firstOrDefault:
    getArgs: alwaysValues(defaultFunc("return value < 20;"), "'defaultValue'")
    argTypes: [argTypes.FUNCTION, argTypes.VALUE]
  filter:
    getArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  groupBy:
    getArgs: alwaysValues(defaultFunc("return value % 2"), defaultFunc("return value;"))
    argTypes: [argTypes.FUNCTION, argTypes.FUNCTION]
  includes:
    getArgs: alwaysValues("5")
    argTypes: singleValueType
  ignoreElements:
    getArgs: alwaysEmpty
    argTypes: []
  indexOf:
    getArgs: alwaysValues("5")
    argTypes: singleValueType
  isEmpty:
    getArgs: alwaysEmpty
    argTypes: []
  last:
    getArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  lastOrDefault:
    getArgs: alwaysValues(defaultFunc("return value < 20;"), 'defaultValue')
    argTypes: singleFunctionType
  map:
    getArgs: alwaysValues(defaultFunc("return value * value;"))
    argTypes: singleFunctionType
  max:
    getArgs: alwaysValues(defaultFunc("return value;"))
    argTypes: singleFunctionType
  mergeAll:
    getArgs: alwaysEmpty
    argTypes: []
  min:
    getArgs: alwaysValues(defaultFunc("return value;"))
    argTypes: singleFunctionType
  pairwise:
    getArgs: alwaysEmpty
    argTypes: []
  pluck:
    getArgs: alwaysValues("'property'")
    argTypes: singleValueType
  reduce:
    getArgs: alwaysValues("function(acc, x) { return acc * x; }", '1')
    argTypes: singleFunctionType
  repeat:
    getArgs: alwaysValues("2")
    argTypes: singleValueType
  retry:
    getArgs: alwaysValues("3")
    argTypes: singleValueType
  sample:
    getArgs: alwaysValues("500")
    argTypes: singleValueType
    useScheduler: true
  scan:
    getArgs: alwaysValues('1',"function(acc, x) { return acc * x; }")
    argTypes: [argTypes.VALUE, argTypes.FUNCTION]
  single:
    getArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  singleOrDefault:
    getArgs: alwaysValues(defaultFunc("return value < 20;"), "'defaultValue'")
    argTypes: [argTypes.FUNCTION, argTypes.VALUE]
  skip:
    getArgs: alwaysValues("5")
    argTypes: singleValueType
  skipLast:
    getArgs: alwaysValues("3")
    argTypes: singleValueType
  skipLastWithTime:
    getArgs: alwaysValues("1000")
    argTypes: singleValueType
    useScheduler: true
  skipUntilWithTime:
    getArgs: alwaysValues("2000")
    argTypes: singleValueType
    useScheduler: true
  startWith:
    getArgs: alwaysValues("1, 2, 3")
    argTypes: singleValueType
  some:
    getArgs: alwaysValues(defaultFunc("return value > 10;"))
    argTypes: singleFunctionType
  sum:
    getArgs: alwaysValues("function(x, idx) { return x; }")
    argTypes: singleFunctionType
  take:
    getArgs: alwaysValues("4")
    argTypes: singleValueType
  takeLast:
    getArgs: alwaysValues("4")
    argTypes: singleValueType
  takeLastBuffer:
    getArgs: alwaysValues("4")
    argTypes: singleValueType
  takeLastBufferWithTime:
    useScheduler: true
    getArgs: alwaysValues("2000")
    argTypes: singleValueType
  takeLastWithTime:
    useScheduler: true
    getArgs: alwaysValues("2000")
    argTypes: singleValueType
  takeUntilWithTime:
    useScheduler: true
    getArgs: alwaysValues("5000")
    argTypes: singleValueType
  takeWhile:
    getArgs: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  timeInterval:
    getArgs: alwaysEmpty
    argTypes: []
    useScheduler: true
  throttleFirst:
    getArgs: alwaysValues("1000")
    argTypes: singleValueType
    useScheduler: true
  timeout:
    getArgs: alwaysValues("1000")
    argTypes: singleValueType
    useScheduler: true
  timestamp:
    getArgs: alwaysEmpty
    argTypes: []
    useScheduler: true
  toArray:
    getArgs: alwaysEmpty
    argTypes: []
  windowWithCount:
    getArgs: alwaysValues("2")
    argTypes: singleValueType
  windowWithTime:
    getArgs: alwaysValues("1000")
    argTypes: singleValueType
    useScheduler: true
  windowWithTimeOrCount:
    getArgs: alwaysValues("1000", "3")
    useScheduler: true
)

getReturningFunctionWithClosedOver = R.compose(getReturningFunctionDeclaration, getClosedOverArgName)

wrapInArray = (val) ->
  [val]

recursiveFunctionOperatorsDefaults =
  recursive: true
  recursionType: 'function'
  argTypes: [argTypes.RECURSIVE_FUNCTION]
  getArgs: getReturningFunctionWithClosedOver
  getDefaultDeclaration: getReturningFunctionWithClosedOver
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
  getArgs: alwaysValues(simpleCombinerFunction)
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
