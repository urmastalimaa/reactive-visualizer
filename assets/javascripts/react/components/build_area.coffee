React = require 'react'
identifyStructure = require '../../builder/structure_identifier'
SimulationHeader = require './simulation_header'
Observable = require './observable'
TimeSlider = require './time_slider'

BuildArea = React.createClass
  getInitialState: ->
    observable: identifyStructure(@props.defaultObservable)

  handleChange: (observable) ->
    identifiedObservable = identifyStructure(observable)
    @setState observable: identifiedObservable
    @props.onChange identifiedObservable

  render: ->
    <div className="buildArea" style={@props.style}>
      <SimulationHeader />
      <Observable observable={@state.observable} id='' ref="observable" recursionLevel=0 onChange={@handleChange} rowLength={@props.rowLength}/>
      <button className="analyze" id="analyze">Analyze</button>
      <button className="play" id="play">Play</button>
      <div>
        <button className="persistency" id="save">Save</button>
        <button className="persistency" id="load">Load</button>
        <button className="persistency" id="clear">Clear</button>
      </div>
      <TimeSlider initialTime={0} initialMin={0} initialMax={3000} initialValue={0}/>
    </div width='inherit'>

module.exports = BuildArea
