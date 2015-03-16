React = require 'react'
R = require 'ramda'

serialize = require '../../builder/serializer'

SimulationHeader = require './simulation_header'
Observable = require './observable'
PersistencyArea = require './persistency'
ResultControl = require './result_control'

module.exports = React.createClass
  getInitialState: ->
    observable: serialize(@props.defaultObservable)

  handleChange: (observable) ->
    @setState observable: serialize(observable)

  render: ->
    <div className="buildArea" style={@props.style}>
      <SimulationHeader />
      <Observable observable={@state.observable} id='' recursionLevel=0 onChange={@handleChange} rowLength={@props.rowLength}/>
      <PersistencyArea defaultObservable={@props.defaultObservable}
        observable={@state.observable} onChange={@handleChange} />
      <ResultControl observable={@state.observable}/>
    </div>
