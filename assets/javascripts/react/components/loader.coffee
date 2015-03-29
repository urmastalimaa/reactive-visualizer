React = require 'react'
R = require 'ramda'
S = require('string')
ModalButton = require './modal_button'
{Button, PanelGroup, Panel} = require 'react-bootstrap'

module.exports = React.createClass
  getInitialState: ->
    modalOpen: false

  mapExample: R.curryN 3, (deletable, example, index) ->
    {name, description, observable} = example
    humanized = S(name).humanize().s
    clickHandler = R.useWith @selectOption, R.always(observable)

    deleteButton =
      if deletable
        <button className="smallClose" onClick={R.partial(@props.onRemove, example)}>
          &#10006;
        </button>
      else
        <span/>

    <div className="example" key={index}>
      <Button bsStyle="default" onClick={clickHandler}>
        {humanized}
      </Button>
      {deleteButton}
      <span className="loadDescription">
        {description}
      </span>
    </div>

  selectOption: (observable) ->
    @props.onLoad(observable)
    @refs.modalButton.setState open: false

  render: ->
    examples =
      <PanelGroup className="examples" defaultActiveKey='1' accordion>
        <Panel header="Bundled examples" eventKey='1'>
          {R.mapIndexed(R.partial(@mapExample, false))(@props.bundledExamples)}
        </Panel>
        <Panel header="User examples" eventKey='2'>
          {R.mapIndexed(R.partial(@mapExample, true))(@props.userExamples)}
        </Panel>
      </PanelGroup>

    <ModalButton ref="modalButton" id="load" title="Load an example" buttonText="Load">
      {examples}
    </ModalButton>

