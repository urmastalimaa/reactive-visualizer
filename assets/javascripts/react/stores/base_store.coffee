EventEmitter = require('events').EventEmitter

class StoreEmitter extends EventEmitter
  CHANGE_EVENT = 'change'

  emitChange: ->
    @emit(CHANGE_EVENT)

  addChangeListener: (callback) ->
    @on(CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @removeListener(CHANGE_EVENT, callback)

module.exports = StoreEmitter
