React = require 'react'
R = require 'ramda'
S = require('string')
ReactBootstrap = require 'react-bootstrap'
{Modal, Button} = ReactBootstrap

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
    @hideModal()
    @props.onChange(optionKey)

  hideModal: ->
    React.render(<span/>, @refs.loadContainer.getDOMNode())

  showModal: ->
    modalContent = R.mapObjIndexed(@mapOption)(@props.options)

    modalInstance = (
        <div id="loadModal" className="static-modal">
          <Modal title="Load an example"
            bsStyle="primary"
            backdrop={false}
            animation={true}
            container={@refs.loadContainer}
            onRequestHide={@hideModal}>
            <div className="modal-body">
              {modalContent}
            </div>
          </Modal>
        </div>
      )
    React.render(modalInstance, @refs.loadContainer.getDOMNode())

  render: ->
    <div id="loadArea">
      <span id="loadContainer" ref="loadContainer"/>
      <button id="loadButton" onClick={@showModal}>Load</button>
    </div>

