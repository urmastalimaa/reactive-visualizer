React = require 'react'
R = require 'ramda'
Persister = require '../../persistency/persister'
examples = require '../../../../example_observables'
Loader = require './loader'
Saver = require './saver'

ReactBootstrap = require 'react-bootstrap'
{Button, ButtonToolbar, ButtonGroup} = ReactBootstrap

module.exports = React.createClass
  getInitialState: ->
    userExamples: Persister.allExamples()

  onLoad: (observable) ->
    @props.onChange observable

  onRemove: (example) ->
    newExamples = Persister.removeExample(example)
    @setState userExamples: newExamples

  onSave: ({name, description}) ->
    newExamples = Persister.addExample
      name: name
      description: description
      observable: @props.observable
    @setState userExamples: newExamples

  render: ->
    <ButtonToolbar id="persistency" className="persistencyArea">
      <ButtonGroup>
        <Loader onLoad={@onLoad} onRemove={@onRemove} bundledExamples={examples} userExamples={@state.userExamples}/>
      </ButtonGroup>
      <ButtonGroup>
        <Saver onSave={@onSave} />
      </ButtonGroup>
    </ButtonToolbar>

