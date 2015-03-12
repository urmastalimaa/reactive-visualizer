React = require 'react'
R = require 'ramda'

identifyStructure = require '../../builder/structure_identifier'

SimulationHeader = require './simulation_header'
Observable = require './observable'
PersistencyArea = require './persistency'
ResultControl = require './result_control'

module.exports = React.createClass
  getInitialState: ->
    observable: identifyStructure(@props.defaultObservable)

  handleChange: (observable) ->
    @setState observable: identifyStructure(observable)

  render: ->
    <div className="buildArea" style={@props.style}>
      <SimulationHeader />
      <Observable observable={@state.observable} id='' recursionLevel=0 onChange={@handleChange} rowLength={@props.rowLength}/>
      <PersistencyArea defaultObservable={@props.defaultObservable}
        observable={@state.observable} onChange={@handleChange} />
      <ResultControl observable={@state.observable}/>
    </div>
