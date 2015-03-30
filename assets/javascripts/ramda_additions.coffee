R = require 'ramda'

ensureFunction = (val) ->
  (typeof val is 'function') && val || R.always(val)

propMap = R.curry (prop, fn, obj) ->
  R.assoc(prop, fn(R.prop(prop, obj)), obj)

module.exports = R.merge(R, {
  ensureFunction
  propMap
})

