require '../react_test_helper'
sinon = require 'sinon'

describe 'Loader', ->
  props = memo().is -> {}

  getLoadButton = findExamples = getSelectExample =
    getExampleDescription = modalCount = findRemoveExample = null

  beforeEach ->
    Loader = require assetPath + 'react/components/loader'
    @loader = loader = render(React.createElement(Loader, props()))
    getLoadButton = -> findByTag(loader, 'button')
    modalCount = -> scryByClass(loader, 'modal-body').length
    findExamples = -> scryByClass(loader, 'example')
    getSelectExample = -> findByClass(loader, 'selectExample')
    getExampleDescription = -> findByClass(loader, 'exampleDescription')
    findRemoveExample = -> scryByClass(loader, 'smallClose')

  context 'clicking the button', ->
    beforeEach ->
      Simulate.click(getLoadButton())

    it 'opens a modal', ->
      expect(modalCount()).toEqual(1)

    context 'when there is an example', ->
      description = 'description'
      observable = 'exampleObservable'

      props.is ->
        userExamples: [name: 'example', description: description, observable: observable]
        onLoad: sinon.stub()

      it 'shows the select button', ->
        expect(getSelectExample()).toExist()

      it 'shows the description', ->
        expect(getExampleDescription().getDOMNode().innerHTML).toEqual(description)

      context 'when clicking on an example', ->
        beforeEach -> Simulate.click(getSelectExample())

        it 'closes the modal', ->
          expect(modalCount()).toEqual(0)

        it 'calls the onload callback', ->
          sinon.assert.calledWith(props().onLoad, observable)

    context 'when the example is bundled', ->
      props.is ->
        bundledExamples: [name: 'example', description: '', observable: 'exampleObservable']

      it 'cannot be removed', ->
        expect(findRemoveExample()).toEqual([])

    context 'when the example is used provided', ->
      example = name: 'example', description: '', observable: 'exampleObservable'
      props.is ->
        userExamples: [example]
        onRemove: sinon.stub()

      context 'when it is deleted', ->
        beforeEach ->
          Simulate.click(findRemoveExample()[0])

        it 'calls the onRemove callback', ->
          sinon.assert.calledWith(props().onRemove, example)

