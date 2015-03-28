React = require 'react'
R = require 'ramda'
{Modal, Button} = require 'react-bootstrap'

ModalButton = React.createClass
  getDefaultProps: ->
    id: 'id'
    title: 'Modal'
    buttonText: 'Button'
    open: false
    onOpenClose: (isOpen) -> (->)

  getEmptyModalInstance: ->
    <span />

  getModalInstance: ->
    <Modal title={@props.title} bsStyle="primary"
      backdrop={true}
      animation={true}
      container={@refs.modalContainer}
      onRequestHide={@props.onOpenClose(false)}>
      <div className="modal-body">
        {@props.children}
      </div>
    </Modal>

  render: ->
    <span id={@props.id} className="modalButtonContainer">
      <Button bsStyle="primary" className="modalButton" onClick={@props.onOpenClose(true)}>
        {@props.buttonText}
      </Button>
      <span id={"#{@props.id}modalContainer"} ref="modalContainer">
      {if @props.open then @getModalInstance() else @getEmptyModalInstance() }
      </span>
    </span>

module.exports = ModalButton
