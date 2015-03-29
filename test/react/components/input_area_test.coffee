require '../react_test_helper'
sinon = require 'sinon'

describe 'InputArea', ->
  componentArgs = memo().is -> {}

  beforeEach ->
    InputArea = require assetPath + 'react/components/input_area'
    @inputArea = render(React.createElement(InputArea, componentArgs()))
    @textarea = TestUtils.findRenderedDOMComponentWithTag(@inputArea,
      'textarea')

  it 'creates a textarea node', ->
    expect(@textarea.getDOMNode()).toExist()

  context 'with a value property', ->
    componentArgs.is -> value: '5'

    it 'initializes the textarea with the value', ->
      expect(@textarea.getDOMNode().value).toEqual('5')

  context 'typing into the textarea', ->
    componentArgs.is ->
      value: 5
      onChange: sinon.stub()

    beforeEach ->
      Simulate.change(@textarea.getDOMNode(), target: { value: '51'})

    it "changes the value", ->
      expect(@textarea.getDOMNode().value).toEqual('51')

    it "doesn't call the onChange callback", ->
      sinon.assert.notCalled(componentArgs().onChange)

    context 'followed by blur', ->
      beforeEach ->
        Simulate.blur(@textarea.getDOMNode())

      it "calls the onChange callback", ->
        sinon.assert.calledWith(componentArgs().onChange, '51')
