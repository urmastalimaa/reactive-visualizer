React = require 'react'
ModalButton = require './modal_button'
{Button} = require 'react-bootstrap'
R = require 'ramda'

Saver = React.createClass

  getInitialState: ->
    name: ""
    description: ""

  save: ->
    @props.onSave(R.pick(['name', 'description'])(@state))
    @refs.modalButton.setState open: false
    @setState @getInitialState()

  nameInput: ->
    onChange = (event) =>
      @setState name: event.target.value
    <input id="saveNameInput" type="text" placeholder="...name" onChange={onChange} value={@state.name} />

  descriptionInput: ->
    onChange = (event) =>
      @setState description: event.target.value
    <textarea id="saveDescriptionInput" placeholder="...description" onChange={onChange} value={@state.description}/>

  saveButton: ->
    if @state.name && @state.description
      <Button id="saveConfirm" bsStyle="success" onClick={@save}>
        Save
      </Button>

  render: ->
    <ModalButton ref="modalButton" id="save" title="Save an example" buttonText="Save">
      {@nameInput()}
      {@descriptionInput()}
      {@saveButton()}
    </ModalButton>

module.exports = Saver
