R = require 'ramda'

argTypes = require './argument_types'

roots =
  of:
    args: ["1,2,3"]
    argTypes: [argTypes.VALUE]
  just:
    args: [5]
    argTypes: [argTypes.VALUE]
  fromTime:
    args: ["{500: 1, 1000: 2, 3000: 3}"]
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  interval:
    args: [1000]
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]
  timer:
    args: [500, 2000]
    argTypes: [argTypes.VALUE, argTypes.VALUE, argTypes.SCHEDULER]
  repeat:
    args: [42, 3]
    argTypes: [argTypes.VALUE, argTypes.VALUE, argTypes.SCHEDULER]
  generate:
    args: [0, "function(x){ return x < 3;}", "function(x) { return x + 1;}", "function(x) { return x; }"]
    argTypes: [argTypes.VALUE, argTypes.FUNCTION, argTypes.FUNCTION, argTypes.FUNCTION, argTypes.SCHEDULER]
  generateWithRelativeTime:
    args: [1, "function(x) { return x < 4;}", "function(x) { return x + 1;}", "function(x) { return x; }", "function(x) { return 500 * x; }"]
    argTypes: [argTypes.VALUE, argTypes.FUNCTION, argTypes.FUNCTION, argTypes.FUNCTION, argTypes.FUNCTION, argTypes.SCHEDULER]
  never:
    args: []
    argTypes: []
  empty:
    args: []
    argTypes: [argTypes.SCHEDULER]
  range:
    args: [1, 5]
    argTypes: [argTypes.VALUE, argTypes.VALUE, argTypes.SCHEDULER]
  pairs:
    args: ["{foo: 42, bar: 56, baz: 78}"]
    argTypes: [argTypes.VALUE, argTypes.SCHEDULER]

sortByKeys = R.compose(R.fromPairs, R.sortBy(R.nthArg(0)), R.toPairs)

module.exports = sortByKeys(roots)
