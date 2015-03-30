require '../react_test_helper'
sinon = require 'sinon'
R = require 'ramda'

describe 'RootComponent', ->
  props = memo().is -> {}

  getRootSelector = getInput =  null

  beforeEach ->
    Root = require assetPath + 'react/components/root_component'
    @root = root = render(React.createElement(Root, props()))
    getRootSelector = -> findByClass(root, 'selectRoot')
    getInput = (pos) -> scryByClass(root, 'codeTextarea')[pos]

  it 'can be rendered', ->

  context 'with simple root', ->
    type = 'timer'
    args = [300, 400]
    props.is ->
      root: {type: type, args: args}
      handleChange: sinon.stub()

    it 'has the correct root selected', ->
      expect(getRootSelector().getDOMNode().value).toEqual(type)

    it 'has correctly populated arguments', ->
      R.forEachIndexed( (arg, index) ->
        expect(getInput(index).getDOMNode().value).toEqual(arg)
      )(args)

    context 'when changing an argument', ->
      newFirstArg = 500
      beforeEach ->
        Simulate.change(getInput(0), target: {value: newFirstArg})
        Simulate.blur(getInput(0))

      it 'calls onChange', ->
        sinon.assert.calledWith(props().handleChange, type: type, args: [newFirstArg, 400])

    context 'when changing type', ->
      newType = 'interval'
      beforeEach ->
        Simulate.change(getRootSelector(), target: {value: newType})

      it 'calls onChange', ->
        sinon.assert.calledWith(props().handleChange, type: newType, args: [1000])

