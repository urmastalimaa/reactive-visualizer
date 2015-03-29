require '../../test_helper'
InputArea = require assetPath + 'react/components/input_area'
jsdom = require('jsdom')
React = require 'react'
sinon = require 'sinon'

{TestUtils} = require('react/addons').addons

global.document = jsdom.jsdom('<!doctype html><html><body></body></html>')
global.window = document.parentWindow

render = (component) ->
  renderTarget = document.getElementsByTagName('body')[0]
  renderedComponent = React.render(component, renderTarget)

describe 'InputArea', ->
  componentArgs = memo().is -> {}

  beforeEach ->
    @renderedComponent = render(React.createElement(InputArea, componentArgs()))
    @textarea = TestUtils.findRenderedDOMComponentWithTag(@renderedComponent,
      'textarea')

  afterEach ->
    # clean the DOM
    render(React.createElement("span"))

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
      TestUtils.Simulate.change(@textarea.getDOMNode(), target: { value: '51'})

    it "changes the value", ->
      expect(@textarea.getDOMNode().value).toEqual('51')

    it "doesn't call the onChange callback", ->
      sinon.assert.notCalled(componentArgs().onChange)

    context 'followed by blur', ->
      beforeEach ->
        TestUtils.Simulate.blur(@textarea.getDOMNode())

      it "calls the onChange callback", ->
        sinon.assert.calledWith(componentArgs().onChange, '51')
