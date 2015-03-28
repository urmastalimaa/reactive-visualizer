React = require 'react'
ModalButton = require './modal_button'
{Button} = require 'react-bootstrap'
R = require 'ramda'

Saver = React.createClass

  getInitialState: ->
    modalOpen: false
    name: ""
    description: ""

  changeName: ->
    @setState name: @refs.name.getDOMNode().value

  changeDescription: ->
    @setState description: @refs.description.getDOMNode().value

  save: ->
    @props.onSave(name: @state.name, description: @state.description)
    @setState @getInitialState()

  nameInput: ->
    <div>
      <input ref="name" required={true} type="text" placeholder="...name" onChange={@changeName} value={@state.name} />
    </div>

  descriptionInput: ->
    <div>
      <textarea ref="description" required={true} placeholder="...description" onChange={@changeDescription} value={@state.description}/>
    </div>

  saveButton: ->
    if @state.name && @state.description
      <Button bsStyle="success" onClick={@save}>
        Save
      </Button>
    else
      <span/>

  componentDidUpdate: (prevProps, prevState) ->
    if !prevState.modalOpen && @state.modalOpen
      @refs.name.getDOMNode().focus()

  render: ->
    openCloseModal = (isOpen) =>
      R.nAry 0, R.partial(@setState.bind(@), modalOpen: isOpen)

    <ModalButton ref="modalButton" id="save" title="Save an example" buttonText="Save" open={@state.modalOpen} onOpenClose={openCloseModal} >
      {@nameInput()}
      {@descriptionInput()}
      {@saveButton()}
    </ModalButton>

module.exports = Saver
