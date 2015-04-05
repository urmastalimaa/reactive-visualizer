React = require 'react'

InteractionArea = require './components/interaction_area'
Persister = require '../persister'
examples = require '../../../example_observables'
Manual = require './manual'

Page = React.createClass
  render: ->
    startingStructure = Persister.load() || examples[0].observable

    <div id="page">
      <Manual />
      <InteractionArea defaultObservable={startingStructure} />
    </div>

module.exports = Page
