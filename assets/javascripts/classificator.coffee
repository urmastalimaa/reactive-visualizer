R = require './ramda_additions'

argTypes = require './descriptors/argument_types'
simpleArgTypes = [argTypes.FUNCTION, argTypes.VALUE, argTypes.SCHEDULER]

isSimple = (definition) ->
  R.difference(definition.argTypes, simpleArgTypes).length == 0

module.exports =
  isSimple: isSimple
