React = require 'react'
R = require 'ramda'
{Modal, Button} = require 'react-bootstrap'

ModalButton = React.createClass
  getDefaultProps: ->
    id: 'id'
    title: 'Modal'
    buttonText: 'Button'

  getInitialState: ->
    open: false

  open: ->
    @setState open: true

  close: ->
    @setState open: false

  getEmptyModalInstance: ->
    <span />

  getModalInstance: ->
    <Modal title={@props.title} bsStyle="primary"
      backdrop={true}
      animation={true}
      container={@refs.modalContainer}
      onRequestHide={@close}>
      <div className="modal-body">
        {@props.children}
      </div>
    </Modal>

  render: ->
    <span id={@props.id} className="modalButtonContainer">
      <Button id={"#{@props.id}Button"} bsStyle="primary" className="modalButton" onClick={@open}>
        {@props.buttonText}
      </Button>
      <span id={"#{@props.id}modalContainer"} ref="modalContainer">
      {if @state.open then @getModalInstance() else @getEmptyModalInstance() }
      </span>
    </span>

module.exports = ModalButton
