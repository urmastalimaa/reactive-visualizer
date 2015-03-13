React = require 'react'

BuildArea = require './react/components/build_area'
Persister = require './persistency/persister'
defaultStructure = require './default_observable'

document.addEventListener "DOMContentLoaded", ->
  startingStructure = Persister.load() || defaultStructure

  React.render(
    <BuildArea defaultObservable={startingStructure} />,
    document.getElementById('content')
  )

