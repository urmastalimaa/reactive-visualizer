React = require 'react'
R = require 'ramda'
S = require('string')
ReactBootstrap = require 'react-bootstrap'
{Modal, Button, ButtonToolbar} = ReactBootstrap

module.exports = React.createClass

  mapOption: (description, optionKey)->
    humanized = S(optionKey).humanize().s
    clickHandler = R.useWith @selectOption, R.always(optionKey)

    <div className="loadOption">
      <Button bsStyle="default" onClick={clickHandler}>
        {humanized}
      </Button>
      <span className="loadDescription">
        {description}
      </span>
    </div>

  selectOption: (optionKey) ->
    @props.onChange(optionKey)
    @hideModalWithTimeout()

  hideModal: ->
    React.render(<span/>, @refs.loadContainer.getDOMNode())

  hideModalWithTimeout: ->
    setTimeout @hideModal

  showModal: ->
    modalContent =
      <div className="loadOptions">
        {R.mapObjIndexed(@mapOption)(@props.options)}
      </div>
    modalInstance = (
        <div id="loadModal" className="static-modal">
          <Modal title="Load an example"
            bsStyle="primary"
            backdrop={true}
            animation={true}
            container={@refs.loadContainer}
            onRequestHide={@hideModalWithTimeout}>
            <div className="modal-body">
              {modalContent}
            </div>
          </Modal>
        </div>
      )
    React.render(modalInstance, @refs.loadContainer.getDOMNode())

  render: ->
    <span id="loadArea">
      <Button bsStyle="primary" id="loadButton" onClick={@showModal}>
        Load
      </Button>
      <span id="loadContainer" ref="loadContainer"/>
    </span>

