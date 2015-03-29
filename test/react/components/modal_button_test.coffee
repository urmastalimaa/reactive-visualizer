require '../react_test_helper'
sinon = require 'sinon'


describe 'ModalButton', ->
  props = memo().is -> {}

  findModals = getOpenButton = getCloseButton = null

  beforeEach ->
    ModalButton = require assetPath + 'react/components/modal_button'
    modalButton = render(React.createElement(ModalButton, props()))

    findModals = -> scryByClass(modalButton, 'modal-body')
    getOpenButton = -> findByTag(modalButton, 'button')
    getCloseButton = -> findByClass(modalButton, 'close')

  it 'creates a button', ->
    expect(getOpenButton().getDOMNode()).toExist()

  it "doesn't open a modal", ->
    expect(findModals()).toEqual([])

  context 'with button text', ->
    props.is -> buttonText: 'Click Me'

    it 'creates a button with the provided text', ->
      expect(getOpenButton().getDOMNode().innerHTML).toEqual(props().buttonText)

  context 'when button is clicked', ->
    beforeEach ->
      Simulate.click(getOpenButton())

    it 'opens modal', ->
      expect(findModals().length).toEqual(1)

    context 'when x is clicked', ->
      beforeEach ->
        Simulate.click(getCloseButton())

      it 'closes modal', ->
        expect(findModals().length).toEqual(0)
