require '../react_test_helper'
sinon = require 'sinon'

describe 'Loader', ->
  props = memo().is -> {}

  getLoadButton = findModals = findExamples = null

  beforeEach ->
    Loader = require assetPath + 'react/components/loader'
    @loader = loader = render(React.createElement(Loader, props()))
    getLoadButton = ->
      document.getElementById('loadButton')
    findModals = -> scryByClass(loader, 'modal-body')
    findExamples = -> scryByClass(loader, 'example')

  context 'clicking the button', ->
    beforeEach ->
      Simulate.click(getLoadButton())

    it 'opens a modal', ->
      expect(findModals().length).toEqual(1)

    context 'when clicking on an example', ->
      props.is ->
        bundledExamples: [name: 'example', description: '', observable: 'exampleObservable']
        onLoad: sinon.stub()

      beforeEach ->
        button = scryByTag(findExamples()[0], 'button')[0]
        Simulate.click(button)

      it 'closes the modal', ->
        expect(findModals().length).toEqual(0)

      it 'calls the onload callback', ->
        sinon.assert.calledWith(props().onLoad, props().bundledExamples[0].observable)

    context 'when the example is bundled', ->
      props.is ->
        bundledExamples: [name: 'example', description: '', observable: 'exampleObservable']

      it 'cannot be removed', ->
        closeButton = scryByClass(@loader, 'smallClose')
        expect(closeButton).toEqual([])

    context 'when the example is used provided', ->
      props.is ->
        userExamples: [name: 'example', description: '', observable: 'exampleObservable']
        onRemove: sinon.stub()

      context 'when it is deleted', ->
        beforeEach ->
          button = findByClass(@loader, 'smallClose')
          Simulate.click(button)

        it 'calls the onRemove callback', ->
          sinon.assert.calledWith(props().onRemove, props().userExamples[0])

