React = require 'react'
R = require 'ramda'

Persister = require '../../persister'
examples = require '../../../../example_observables'

Loader = require './loader'
Saver = require './saver'
{Button, ButtonToolbar, ButtonGroup} = require 'react-bootstrap'

Persistence =  React.createClass

  getDefaultProps: ->
    observable: {}
    userExamples: []
    bundledExamples: []
    onLoad: ->

  getInitialState: ->
    userExamples: Persister.allExamples()

  onLoad: (observable) ->
    @props.onLoad observable

  onRemove: (example) ->
    newExamples = Persister.removeExample(example)
    @setState userExamples: newExamples

  onSave: ({name, description}) ->
    newExamples = Persister.addExample
      name: name
      description: description
      observable: @props.observable
    @setState userExamples: newExamples

  componentWillReceiveProps: (props) ->
    # Save the observable immediately when changed
    Persister.save(props.observable)

  render: ->
    <ButtonToolbar id="persistence">
      <ButtonGroup>
        <Loader onLoad={@onLoad} onRemove={@onRemove} bundledExamples={examples} userExamples={@state.userExamples}/>
      </ButtonGroup>
      <ButtonGroup>
        <Saver onSave={@onSave} />
      </ButtonGroup>
    </ButtonToolbar>

module.exports = Persistence
