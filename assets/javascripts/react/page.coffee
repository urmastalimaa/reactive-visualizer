React = require 'react'

BuildArea = require './components/build_area'
Persister = require '../persistency/persister'
examples = require '../../../example_observables'
Description = require './description'

Page = React.createClass
  render: ->
    startingStructure = Persister.load() || examples[0].observable

    <div>
      <Description />
      <BuildArea defaultObservable={startingStructure} />
    </div>

module.exports = Page
