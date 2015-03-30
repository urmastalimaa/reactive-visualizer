React = require 'react'
R = require 'ramda'

identify = require '../../builder/identifier'

SimulationHeader = require './simulation_header'
Observable = require './observable'
PersistencyArea = require './persistency'
Persister = require '../../persistency/persister'
ResultControl = require './result_control'
examples = require '../../../../example_observables'

BuildArea = React.createClass
  getDefaultProps: ->
    defaultObservable: examples[0].observable

  getInitialState: ->
    observable: identify(@props.defaultObservable)

  handleChange: (observable) ->
    Persister.save(observable)
    @setState observable: identify(observable)

  render: ->
    <div id="buildArea" style={@props.style}>
      <SimulationHeader />
      <Observable observable={@state.observable} id='' recursionLevel=0 onChange={@handleChange} rowLength={@props.rowLength}/>
      <ResultControl observable={@state.observable}/>

      <PersistencyArea defaultObservable={@props.defaultObservable}
        observable={@state.observable} onChange={@handleChange} />
    </div>

module.exports = BuildArea
