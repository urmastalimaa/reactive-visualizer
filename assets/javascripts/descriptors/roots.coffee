R = require 'ramda'

argTypes = require './argument_types'
alwaysValues = ->
  R.always(Array.prototype.slice.call(arguments))
singleValueType = [argTypes.VALUE]
singleFunctionType = [argTypes.FUNCTION]
alwaysEmpty = R.always([])

roots =
  of:
    getDefaultArgs: alwaysValues("1,2,3")
    argTypes: singleValueType
    useScheduler: false
  just:
    getDefaultArgs: alwaysValues("5")
    argTypes: singleValueType
    useScheduler: true
  fromTime:
    getDefaultArgs: alwaysValues("{500: 1, 1000: 2, 3000: 3}")
    argTypes: singleValueType
    useScheduler: true
  interval:
    getDefaultArgs: alwaysValues("1000")
    argTypes: singleValueType
    useScheduler: true
  timer:
    getDefaultArgs: alwaysValues("500, 2000")
    argTypes: [argTypes.VALUE, argTypes.VALUE]
    useScheduler: true
  repeat:
    getDefaultArgs: alwaysValues("42", "3")
    argTypes: [argTypes.VALUE, argTypes.VALUE]
    useScheduler: true
  generate:
    getDefaultArgs: alwaysValues("0", "function(x){ return x < 3;}", "function(x) { return x + 1;}", "function(x) { return x; }")
    argTypes: [argTypes.VALUE, argTypes.FUNCTION, argTypes.FUNCTION, argTypes.FUNCTION]
    useScheduler: true
  generateWithRelativeTime:
    getDefaultArgs: alwaysValues("1", "function(x) { return x < 4;}", "function(x) { return x + 1;}", "function(x) { return x; }", "function(x) { return 500 * x; }")
    argTypes: [argTypes.VALUE, argTypes.FUNCTION, argTypes.FUNCTION, argTypes.FUNCTION, argTypes.FUNCTION]
    useScheduler: true
  never:
    argTypes: alwaysEmpty
    argTypes: []
    useScheduler: false
  empty:
    argTypes: alwaysEmpty
    argTypes: []
    useScheduler: true
  range:
    getDefaultArgs: alwaysValues("1, 5")
    argTypes: [argTypes.VALUE, argTypes.VALUE]
    useScheduler: true
  pairs:
    getDefaultArgs: alwaysValues("{foo: 42, bar: 56, baz: 78}")
    argTypes: singleValueType
    useScheduler: true

sortByKeys = R.compose(R.fromPairs, R.sortBy(R.nthArg(0)), R.toPairs)

module.exports = sortByKeys(roots)
