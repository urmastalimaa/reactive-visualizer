React = require 'react'
R = require 'ramda'

serialize = require '../../builder/serializer'

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
    observable: serialize(@props.defaultObservable)

  handleChange: (observable) ->
    Persister.save(serialize(observable))
    @setState observable: serialize(observable)

  render: ->
    <div id="buildArea" style={@props.style}>
      <SimulationHeader />
      <Observable observable={@state.observable} id='' recursionLevel=0 onChange={@handleChange} rowLength={@props.rowLength}/>
      <ResultControl observable={@state.observable}/>

      <PersistencyArea defaultObservable={@props.defaultObservable}
        observable={@state.observable} onChange={@handleChange} />
    </div>

module.exports = BuildArea
