React = require 'react'

Interaction = require './components/interaction'
Persister = require '../persister'
examples = require '../../../example_observables'
Manual = require './manual'

Page = React.createClass
  render: ->
    startingStructure = Persister.load() || examples[0].observable

    <div id="page">
      <Manual />
      <Interaction defaultObservable={startingStructure} />
    </div>

module.exports = Page
