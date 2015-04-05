require '../react_test_helper'
sinon = require 'sinon'
R = require 'ramda'

describe 'FactoryComponent', ->
  props = memo().is -> {}

  getFactorySelector = getInput =  null

  beforeEach ->
    Factory = require assetPath + 'react/components/factory_component'
    @factory = factory = render(React.createElement(Factory, props()))
    getFactorySelector = -> findByClass(factory, 'selectFactory')
    getInput = (pos) -> scryByClass(factory, 'codeTextarea')[pos]

  it 'can be rendered', ->

  context 'with simple factory', ->
    type = 'timer'
    args = [300, 400]
    props.is ->
      factory: {type: type, args: args}
      handleChange: sinon.stub()

    it 'has the correct factory selected', ->
      expect(getFactorySelector().getDOMNode().value).toEqual(type)

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
        Simulate.change(getFactorySelector(), target: {value: newType})

      it 'calls onChange', ->
        sinon.assert.calledWith(props().handleChange, type: newType, args: [1000])

