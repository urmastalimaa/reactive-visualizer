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

simpleOperatorsDefaults = {}

alwaysValues = ->
  R.always(Array.prototype.slice.call(arguments))
singleValueType = [argTypes.VALUE]
singleFunctionType = [argTypes.FUNCTION]
alwaysEmpty = R.always([])

simpleOperators = R.mapObj(R.merge(simpleOperatorsDefaults))(
  average:
    args: alwaysValues('function(x) { return x; }')
    argTypes: singleFunctionType
  bufferWithCount:
    args: alwaysValues("2")
    argTypes: singleValueType
  bufferWithTime:
    args: alwaysValues('1000')
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  bufferWithTimeOrCount:
    args: alwaysValues('1000', '3')
    argTypes: [argTypes.VALUE, argTypes.VALUE, argTypes.SCHEDULER]
  concatAll:
    argTypes: []
    args: alwaysEmpty
  count:
    argTypes: []
    args: alwaysEmpty
  debounce:
    args: alwaysValues('1000')
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  defaultIfEmpty:
    argTypes: singleValueType
    args: alwaysValues("'defaultValue'")
  delay:
    args: alwaysValues('1000')
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  distinct:
    argTypes: singleFunctionType
    args: alwaysValues("function(x) { return x % 2 }")
  distinctUntilChanged:
    argTypes: singleFunctionType
    args: alwaysValues("function(x) { return x % 2 }")
  elementAt:
    args: alwaysValues('1')
    argTypes: singleValueType
  elementAtOrDefault:
    args: alwaysValues('1', "'defaultValue'")
    argTypes: [argTypes.VALUE, argTypes.VALUE]
  every:
    args: alwaysValues("function(x) { return x % 2 == 0 }")
    argTypes: singleFunctionType
  find:
    args: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  first:
    args: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  firstOrDefault:
    args: alwaysValues(defaultFunc("return value < 20;"), "'defaultValue'")
    argTypes: [argTypes.FUNCTION, argTypes.VALUE]
  filter:
    args: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  groupBy:
    args: alwaysValues(defaultFunc("return value % 2"), defaultFunc("return value;"))
    argTypes: [argTypes.FUNCTION, argTypes.FUNCTION]
  includes:
    args: alwaysValues("5")
    argTypes: singleValueType
  ignoreElements:
    args: alwaysEmpty
    argTypes: []
  indexOf:
    args: alwaysValues("5")
    argTypes: singleValueType
  isEmpty:
    args: alwaysEmpty
    argTypes: []
  last:
    args: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  lastOrDefault:
    args: alwaysValues(defaultFunc("return value < 20;"), 'defaultValue')
    argTypes: singleFunctionType
  map:
    args: alwaysValues(defaultFunc("return value * value;"))
    argTypes: singleFunctionType
    docAlias: 'select'
  max:
    args: alwaysValues(defaultFunc("return value;"))
    argTypes: singleFunctionType
  mergeAll:
    args: alwaysEmpty
    argTypes: []
  min:
    args: alwaysValues(defaultFunc("return value;"))
    argTypes: singleFunctionType
  pairwise:
    args: alwaysEmpty
    argTypes: []
  pluck:
    args: alwaysValues("'property'")
    argTypes: singleValueType
  reduce:
    args: alwaysValues("function(acc, x) { return acc * x; }", '1')
    argTypes: singleFunctionType
  repeat:
    args: alwaysValues("2")
    argTypes: singleValueType
  retry:
    args: alwaysValues("3")
    argTypes: singleValueType
  sample:
    args: alwaysValues("500")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  scan:
    args: alwaysValues('1',"function(acc, x) { return acc * x; }")
    argTypes: [argTypes.VALUE, argTypes.FUNCTION]
  single:
    args: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  singleOrDefault:
    args: alwaysValues(defaultFunc("return value < 20;"), "'defaultValue'")
    argTypes: [argTypes.FUNCTION, argTypes.VALUE]
  skip:
    args: alwaysValues("5")
    argTypes: singleValueType
  skipLast:
    args: alwaysValues("3")
    argTypes: singleValueType
  skipLastWithTime:
    args: alwaysValues("1000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  skipUntilWithTime:
    args: alwaysValues("2000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  startWith:
    args: alwaysValues("1, 2, 3")
    argTypes: singleValueType
  some:
    args: alwaysValues(defaultFunc("return value > 10;"))
    argTypes: singleFunctionType
  sum:
    args: alwaysValues("function(x, idx) { return x; }")
    argTypes: singleFunctionType
  take:
    args: alwaysValues("4")
    argTypes: singleValueType
  takeLast:
    args: alwaysValues("4")
    argTypes: singleValueType
  takeLastBuffer:
    args: alwaysValues("4")
    argTypes: singleValueType
  takeLastBufferWithTime:
    args: alwaysValues("2000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  takeLastWithTime:
    args: alwaysValues("2000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  takeUntilWithTime:
    args: alwaysValues("5000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  takeWhile:
    args: alwaysValues(defaultFunc("return value < 20;"))
    argTypes: singleFunctionType
  timeInterval:
    args: alwaysEmpty
    argTypes: [argTypes.SCHEDULER]
  throttleFirst:
    args: alwaysValues("1000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  timeout:
    args: alwaysValues("1000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  timestamp:
    args: alwaysEmpty
    argTypes: [argTypes.SCHEDULER]
  toArray:
    args: alwaysEmpty
    argTypes: []
  windowWithCount:
    args: alwaysValues("2")
    argTypes: singleValueType
  windowWithTime:
    args: alwaysValues("1000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  windowWithTimeOrCount:
    args: alwaysValues("1000", "3")
    argTypes: [argTypes.VALUE, argTypes.VALUE, argTypes.SCHEDULER]
)

getReturningFunctionWithClosedOver = R.compose(getReturningFunctionDeclaration, getClosedOverArgName)

wrapInArray = (val) ->
  [val]

recursiveFunctionOperatorsDefaults =
  argTypes: [argTypes.OBSERVABLE_FUNCTION]
  args: [
    functionDeclaration: getReturningFunctionWithClosedOver
    observable:
      root:
        type: 'just'
        args: [
          getClosedOverArgName
        ]
      operators: []
  ]

recursiveFunctionOperators = R.mapObj(R.merge(recursiveFunctionOperatorsDefaults))(
  flatMap: {}
  flatMapLatest: {}
  delayWithSelector:
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable:
        root:
          type: 'timer'
          args: [
            R.compose(R.add("1000 * "), getClosedOverArgName)
          ]
        operators: []
    ]
  buffer:
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable:
        root:
          type: 'timer'
          args: [ R.always("1000") ]
        operators: []
    ]
  concatMap:
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable:
        root:
          type: 'range'
          args: [
            R.compose(
              ((closedOverArg) -> ["0", closedOverArg])
              getClosedOverArgName
            )
          ]
        operators: []
    ]
  debounceWithSelector:
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable:
        root:
          type: 'timer'
          args: [ getClosedOverArgName ]
        operators: []
    ]
  expand:
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable:
        root:
          type: 'just'
          args: [
            R.compose(
              ((arg) -> "#{arg} + #{arg}" )
              getClosedOverArgName
            )
          ]
        operators: []
    ]
  timeoutWithSelector:
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable:
        root:
          type: 'timer'
          args: [
            R.compose(
              ((arg) -> "#{arg} * 100")
              getClosedOverArgName
            )
          ]
        operators: []
    ]
  window:
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable:
        root:
          type: 'timer'
          args: [ R.always("1000") ]
        operators: []
    ]

)

recursiveOperatorDefaults =
  argTypes: [argTypes.OBSERVABLE]

recursiveOperators = R.mapObj(R.merge(recursiveOperatorDefaults))(
  merge:
    args: createSimpleObservable('of')(['1,2'])
  amb:
    args: [
      root:
        type: 'of'
      operators: [
        { type: 'delay', args: [1000] }
      ]
    ]
  concat:
    args: [createSimpleObservable('just')(['5'])]
  sequenceEqual:
    args: [createSimpleObservable('just')(['5'])]
  skipUntil:
    args: [createSimpleObservable('timer')(['1000'])]
  takeUntil:
    args: [createSimpleObservable('timer')(['1000'])]
)

recursiveOperatorsWithTrailingArgsDefaults =
  args: [
    R.always(createSimpleObservable('of')(['1,2']))
    simpleCombinerFunction
  ]
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
