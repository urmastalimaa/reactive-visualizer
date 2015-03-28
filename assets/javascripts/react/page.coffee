React = require 'react'

BuildArea = require './components/build_area'
Persister = require '../persistency/persister'
examples = require '../../../example_observables'

Page = React.createClass
  render: ->
    startingStructure = Persister.load() || examples.simpleMap

    <BuildArea defaultObservable={startingStructure} />

module.exports = Page
