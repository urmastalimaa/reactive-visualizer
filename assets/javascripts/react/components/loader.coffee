React = require 'react'
R = require 'ramda'
S = require('string')
ModalButton = require './modal_button'
{Well, Button, PanelGroup, Panel} = require 'react-bootstrap'

module.exports = React.createClass
  getDefaultProps: ->
    bundledExamples: []
    userExamples: []
    onLoad: ->
    onRemove: ->

  deleteButton: (example) ->
    <button className="smallClose" onClick={R.partial(@props.onRemove, example)}>
      &#10006;
    </button>

  createExample: R.curry (deletable, example, index) ->
    clickHandler = R.partial @selectOption, example.observable

    <Well bsSize='small' key={index} className="example">
      <Button bsStyle="default" onClick={clickHandler} className="selectExample">
        {S(example.name).humanize().toString()}
      </Button>
      {@deleteButton(example) if deletable}
      <span className="exampleDescription">
        {example.description}
      </span>
    </Well>

  selectOption: (observable) ->
    @props.onLoad(observable)
    @refs.modalButton.setState open: false

  render: ->
    examples =
      <PanelGroup className="examples" defaultActiveKey='1' accordion>
        <Panel header="Bundled examples" eventKey='1'>
          {R.mapIndexed(R.partial(@createExample, false))(@props.bundledExamples)}
        </Panel>
        <Panel header="User examples" eventKey='2'>
          {R.mapIndexed(R.partial(@createExample, true))(@props.userExamples)}
        </Panel>
      </PanelGroup>

    <ModalButton ref="modalButton" id="load" title="Load an example" buttonText="Load">
      {examples}
    </ModalButton>

