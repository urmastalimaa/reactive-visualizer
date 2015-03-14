React = require 'react'

BuildArea = require './react/components/build_area'
Persister = require './persistency/persister'
examples = require '../../example_observables'

document.addEventListener "DOMContentLoaded", ->
  startingStructure = Persister.load() || examples.simpleMap

  React.render(
    <BuildArea defaultObservable={startingStructure} />,
    document.getElementById('content')
  )

