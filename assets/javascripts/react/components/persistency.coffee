React = require 'react'
R = require 'ramda'
Persister = require '../../persistency/persister'
examples = require '../../../../example_observables'
Loader = require './load_selector'

module.exports = React.createClass
  save: ->
    Persister.save(@props.observable)

  load: ->
    loaded = Persister.load()
    if loaded
      @props.onChange(loaded)

  onLoad: (exampleKey) ->
    @props.onChange examples[exampleKey]

  clear: ->
    Persister.clear()
    @props.onChange(@props.defaultObservable)

  render: ->
    exampleDescriptions = R.mapObj(R.get('description'))(examples)
    <div>
      <button id="save"  onClick={@save}  >Save</button>
      <button id="save"  onClick={@load}  >Reset</button>
      <button id="clear" onClick={@clear} >Clear</button>
      <Loader onChange={@onLoad} options={exampleDescriptions}/>
    </div>

