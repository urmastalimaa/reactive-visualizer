React = require 'react'
Persister = require '../..//persistency/persister'

module.exports = React.createClass
  save: ->
    Persister.save(@props.observable)

  load: ->
    loaded = Persister.load()
    if loaded
      @props.onChange(loaded)

  clear: ->
    Persister.clear()
    @props.onChange(@props.defaultObservable)

  render: ->
    <div>
      <button id="save"  onClick={@save}  >Save</button>
      <button id="load"  onClick={@load}  >Load</button>
      <button id="clear" onClick={@clear} >Clear</button>
    </div>

