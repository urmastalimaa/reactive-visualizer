React = require 'react'
R = require 'ramda'

examples = require '../../../../example_observables'
identify = require '../../identifier'

InspectorHeader = require './inspector_header'
ObservableEditor = require './observable_editor'
Persistence = require './persistence'
VirtualTimeControl = require './virtual_time_control'

InteractionArea = React.createClass
  getDefaultProps: ->
    defaultObservable: examples[0].observable

  getInitialState: ->
    observable: identify(@props.defaultObservable)

  handleChange: (observable) ->
    @setState observable: identify(observable)

  render: ->
    <div id="interactionArea" style={@props.style}>
      <InspectorHeader />
      <ObservableEditor observable={@state.observable} id='' recursionLevel=0 onChange={@handleChange} rowLength={@props.rowLength}/>
      <VirtualTimeControl observable={@state.observable}/>

      <Persistence observable={@state.observable} onLoad={@handleChange} />
    </div>

module.exports = InteractionArea
