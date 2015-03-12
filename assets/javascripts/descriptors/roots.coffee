R = require 'ramda'

roots =
  of:
    getDefaultArgs: R.always("1,2,3")
    useScheduler: false
  just:
    getDefaultArgs: R.always("5")
    useScheduler: true
  fromTime:
    getDefaultArgs: R.always("{500: 1, 1000: 2, 3000: 3}")
    useScheduler: true
  interval:
    getDefaultArgs: R.always("1000")
    useScheduler: true
  timer:
    getDefaultArgs: R.always("500, 2000")
    useScheduler: true
  repeat:
    getDefaultArgs: R.always("42, 3")
    useScheduler: true
  generate:
    getDefaultArgs: R.always("0, function(x){ return x < 3;}, function(x) { return x + 1;}, function(x) { return x; }")
    useScheduler: true
  generateWithRelativeTime:
    getDefaultArgs: R.always("1, function(x) { return x < 4;}, function(x) { return x + 1;}, function(x) { return x; }, function(x) { return 500 * x; }")
    useScheduler: true
  never:
    useScheduler: false
  empty:
    useScheduler: true
  range:
    getDefaultArgs: R.always("1, 5")
    useScheduler: true
  pairs:
    getDefaultArgs: R.always("{foo: 42, bar: 56, baz: 78}")
    useScheduler: true

sortByKeys = R.compose(R.fromPairs, R.sortBy(R.nthArg(0)), R.toPairs)

module.exports = sortByKeys(roots)
