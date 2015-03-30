R = require 'ramda'

ensureFunction = (val) ->
  (typeof val is 'function') && val || R.always(val)

propMap = R.curry (prop, fn, obj) ->
  R.assoc(prop, fn(R.prop(prop, obj)), obj)


sortByKeys = R.compose(R.fromPairs, R.sortBy(R.nthArg(0)), R.toPairs)

module.exports = R.merge(R, {
  ensureFunction
  propMap
  sortByKeys
})

