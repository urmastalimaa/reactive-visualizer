R = require '../ramda_additions'
argTypes = require './argument_types'

defaultFunc = (impl) ->
  "function(value) { #{impl} }"

createSimpleObservable = R.curryN 2, (rootType, rootArgs) ->
  root:
    type: rootType
    args: rootArgs
  operators: []

getClosedOverArgName = (recursionLevel) ->
  'outerValue' + (recursionLevel || '')

simpleCombinerFunction = 'function(first, second){ return first + second; }'

getReturningFunctionDeclaration = (args) ->
  "function(#{args}) { return "

getReturningFunctionWithClosedOver = R.compose(getReturningFunctionDeclaration, getClosedOverArgName)

arr = -> Array.prototype.slice.call(arguments)

justOverClosedArg =
  root:
    type: 'just'
    args: [
      getClosedOverArgName
    ]
  operators: []

operators =
  average:
    args: arr('function(x) { return x; }')
    argTypes: [argTypes.FUNCTION]
  bufferWithCount:
    args: arr("2")
    argTypes: [argTypes.VALUE]
  bufferWithTime:
    args: arr('1000')
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  bufferWithTimeOrCount:
    args: arr('1000', '3')
    argTypes: [argTypes.VALUE, argTypes.VALUE, argTypes.SCHEDULER]
  concatAll:
    argTypes: []
    args: []
  count:
    argTypes: []
    args: []
  debounce:
    args: arr('1000')
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  defaultIfEmpty:
    argTypes: [argTypes.VALUE]
    args: arr("'defaultValue'")
  delay:
    args: arr('1000')
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  distinct:
    argTypes: [argTypes.FUNCTION]
    args: arr("function(x) { return x % 2 }")
  distinctUntilChanged:
    argTypes: [argTypes.FUNCTION]
    args: arr("function(x) { return x % 2 }")
  elementAt:
    args: arr('1')
    argTypes: [argTypes.VALUE]
  elementAtOrDefault:
    args: arr('1', "'defaultValue'")
    argTypes: [argTypes.VALUE, argTypes.VALUE]
  every:
    args: arr("function(x) { return x % 2 == 0 }")
    argTypes: [argTypes.FUNCTION]
  find:
    args: arr(defaultFunc("return value < 20;"))
    argTypes: [argTypes.FUNCTION]
  first:
    args: arr(defaultFunc("return value < 20;"))
    argTypes: [argTypes.FUNCTION]
  firstOrDefault:
    args: arr(defaultFunc("return value < 20;"), "'defaultValue'")
    argTypes: [argTypes.FUNCTION, argTypes.VALUE]
  filter:
    args: arr(defaultFunc("return value < 20;"))
    argTypes: [argTypes.FUNCTION]
  groupBy:
    args: arr(defaultFunc("return value % 2"), defaultFunc("return value;"))
    argTypes: [argTypes.FUNCTION, argTypes.FUNCTION]
  includes:
    args: arr("5")
    argTypes: [argTypes.VALUE]
  ignoreElements:
    args: []
    argTypes: []
  indexOf:
    args: arr("5")
    argTypes: [argTypes.VALUE]
  isEmpty:
    args: []
    argTypes: []
  last:
    args: arr(defaultFunc("return value < 20;"))
    argTypes: [argTypes.FUNCTION]
  lastOrDefault:
    args: arr(defaultFunc("return value < 20;"), 'defaultValue')
    argTypes: [argTypes.FUNCTION]
  map:
    args: arr(defaultFunc("return value * value;"))
    argTypes: [argTypes.FUNCTION]
    docAlias: 'select'
  max:
    args: arr(defaultFunc("return value;"))
    argTypes: [argTypes.FUNCTION]
  mergeAll:
    args: []
    argTypes: []
  min:
    args: arr(defaultFunc("return value;"))
    argTypes: [argTypes.FUNCTION]
  pairwise:
    args: []
    argTypes: []
  pluck:
    args: arr("'property'")
    argTypes: [argTypes.VALUE]
  reduce:
    args: arr("function(acc, x) { return acc * x; }", '1')
    argTypes: [argTypes.FUNCTION]
  repeat:
    args: arr("2")
    argTypes: [argTypes.VALUE]
  retry:
    args: arr("3")
    argTypes: [argTypes.VALUE]
  sample:
    args: arr("500")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  scan:
    args: arr('1',"function(acc, x) { return acc * x; }")
    argTypes: [argTypes.VALUE, argTypes.FUNCTION]
  single:
    args: arr(defaultFunc("return value < 20;"))
    argTypes: [argTypes.FUNCTION]
  singleOrDefault:
    args: arr(defaultFunc("return value < 20;"), "'defaultValue'")
    argTypes: [argTypes.FUNCTION, argTypes.VALUE]
  skip:
    args: arr("5")
    argTypes: [argTypes.VALUE]
  skipLast:
    args: arr("3")
    argTypes: [argTypes.VALUE]
  skipLastWithTime:
    args: arr("1000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  skipUntilWithTime:
    args: arr("2000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  startWith:
    args: arr("1, 2, 3")
    argTypes: [argTypes.VALUE]
  some:
    args: arr(defaultFunc("return value > 10;"))
    argTypes: [argTypes.FUNCTION]
  sum:
    args: arr("function(x, idx) { return x; }")
    argTypes: [argTypes.FUNCTION]
  take:
    args: arr("4")
    argTypes: [argTypes.VALUE]
  takeLast:
    args: arr("4")
    argTypes: [argTypes.VALUE]
  takeLastBuffer:
    args: arr("4")
    argTypes: [argTypes.VALUE]
  takeLastBufferWithTime:
    args: arr("2000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  takeLastWithTime:
    args: arr("2000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  takeUntilWithTime:
    args: arr("5000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  takeWhile:
    args: arr(defaultFunc("return value < 20;"))
    argTypes: [argTypes.FUNCTION]
  timeInterval:
    args: []
    argTypes: [argTypes.SCHEDULER]
  throttleFirst:
    args: arr("1000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  timeout:
    args: arr("1000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  timestamp:
    args: []
    argTypes: [argTypes.SCHEDULER]
  toArray:
    args: []
    argTypes: []
  windowWithCount:
    args: arr("2")
    argTypes: [argTypes.VALUE]
  windowWithTime:
    args: arr("1000")
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  windowWithTimeOrCount:
    args: arr("1000", "3")
    argTypes: [argTypes.VALUE, argTypes.VALUE, argTypes.SCHEDULER]
  #
  # recursive with function
  #
  flatMap:
    argTypes: [argTypes.OBSERVABLE_FUNCTION]
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable: justOverClosedArg
    ]
  flatMapLatest:
    argTypes: [argTypes.OBSERVABLE_FUNCTION]
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable: justOverClosedArg
    ]
  delayWithSelector:
    argTypes: [argTypes.OBSERVABLE_FUNCTION]
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
    argTypes: [argTypes.OBSERVABLE_FUNCTION]
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable:
        root:
          type: 'timer'
          args: [ R.always("1000") ]
        operators: []
    ]
  concatMap:
    argTypes: [argTypes.OBSERVABLE_FUNCTION]
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
    argTypes: [argTypes.OBSERVABLE_FUNCTION]
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable:
        root:
          type: 'timer'
          args: [ getClosedOverArgName ]
        operators: []
    ]
  expand:
    argTypes: [argTypes.OBSERVABLE_FUNCTION]
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
    argTypes: [argTypes.OBSERVABLE_FUNCTION]
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
    argTypes: [argTypes.OBSERVABLE_FUNCTION]
    args: [
      functionDeclaration: getReturningFunctionWithClosedOver
      observable:
        root:
          type: 'timer'
          args: [ R.always("1000") ]
        operators: []
    ]
  #
  # recursive with unrelated observable
  #
  merge:
    argTypes: [argTypes.OBSERVABLE]
    args: [observable: createSimpleObservable('of')(['1,2'])]
  amb:
    argTypes: [argTypes.OBSERVABLE]
    args: [
      root:
        type: 'of'
      operators: [
        { type: 'delay', args: [1000] }
      ]
    ]
  concat:
    argTypes: [argTypes.OBSERVABLE]
    args: [observable: createSimpleObservable('just')(['5'])]
  sequenceEqual:
    argTypes: [argTypes.OBSERVABLE]
    args: [observable: createSimpleObservable('just')(['5'])]
  skipUntil:
    argTypes: [argTypes.OBSERVABLE]
    args: [observable: createSimpleObservable('timer')(['1000'])]
  takeUntil:
    argTypes: [argTypes.OBSERVABLE]
    args: [observable: createSimpleObservable('timer')(['1000'])]
  #
  # recursive with combiner function
  #
  combineLatest:
    argTypes: [argTypes.OBSERVABLE, argTypes.FUNCTION]
    args: [
      observable: createSimpleObservable('of')(['1,2'])
      simpleCombinerFunction
    ]
  withLatestFrom:
    argTypes: [argTypes.OBSERVABLE, argTypes.FUNCTION]
    args: [
      observable: createSimpleObservable('of')(['1,2'])
      simpleCombinerFunction
    ]
  zip:
    argTypes: [argTypes.OBSERVABLE, argTypes.FUNCTION]
    args: [
      observable: createSimpleObservable('of')(['1,2'])
      simpleCombinerFunction
    ]

module.exports = R.sortByKeys(operators)
