require '../react_test_helper'
sinon = require 'sinon'

describe 'Saver', ->
  props = memo().is -> {}

  getOpenButton = modalCount = getNameInput = getDescriptionInput = getSaveButton = null

  beforeEach ->
    Saver = require assetPath + 'react/components/saver'
    @saver = saver = render(React.createElement(Saver, props()))
    getOpenButton = -> findByTag(saver, 'button')
    modalCount = -> findModals().length
    findModals = -> scryByClass(saver, 'modal-body')
    getNameInput = -> findById(saver, 'saveNameInput')
    getDescriptionInput = -> findById(saver, 'saveDescriptionInput')
    getSaveButton = -> findById(saver, 'saveConfirm')

  context 'clicking the button', ->
    beforeEach ->
      Simulate.click(getOpenButton())

    it 'opens a modal', ->
      expect(modalCount()).toEqual(1)

    context 'changing the name', ->
      name = 'xavier'
      beforeEach -> Simulate.change(getNameInput(), target: {value: name})

      it 'changes the name', ->
        expect(getNameInput().getDOMNode().value).toEqual(name)

    context 'changing the description', ->
      description = 'good boy'

      beforeEach -> Simulate.change(getDescriptionInput(), target: {value: description})

      it 'changes the name', ->
        expect(getDescriptionInput().getDOMNode().value).toEqual(description)

    context 'changing name and description and clicking save', ->
      props.is -> onSave: sinon.stub()
      name = 'xavier'; description = 'good boy'

      beforeEach ->
        Simulate.change(getNameInput(), target: {value: name})
        Simulate.change(getDescriptionInput(), target: {value: description})
        Simulate.click(getSaveButton().getDOMNode())

      it 'calls onSave', ->
        sinon.assert.calledWith(props().onSave, name: name, description: description)

