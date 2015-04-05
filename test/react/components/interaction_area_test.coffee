require '../react_test_helper'
sinon = require 'sinon'
R = require 'ramda'

# TODO test that loading actually changes arguments in inputs

describe 'InteractionArea', ->
  props = memo().is ->

  getTimeSlider = getLastSimulationContent = getArgument = changeArgument = null

  beforeEach ->
    InteractionArea = require assetPath + 'react/components/interaction_area'
    @interactionArea = interactionArea = render(React.createElement(InteractionArea, props()))
    getTimeSlider = -> findById(interactionArea, 'timeSlider')
    getArgument = (id, pos) -> scryByClass(findById(interactionArea, id), 'codeTextarea')[pos]
    getLastSimulationValue = (pos) ->
      area = scryByClass(interactionArea, "simulationArea")[pos]
      R.last(scryByClass(area, 'simulationTimeWrapper'))

    changeArgument = R.curry (id, pos, value) ->
      input = getArgument(id, pos)
      Simulate.change(input, target: {value: value})
      Simulate.blur(input)

    getLastSimulationContent = (pos) -> getLastSimulationValue(pos).getDOMNode().textContent

  expectLastSimulationValues = R.forEachIndexed (value, index) ->
    expect(getLastSimulationContent(index)).toEqual(value)

  context 'changing time slider', ->
    expectedSimulationValues = memo().is ->
    beforeEach ->
      getTimeSlider().handleSliderChange(expectedSimulationValues()[0])

    context 'with the default observable', ->
      expectedSimulationValues.is -> [5001, '3C', '9C']

      it 'has correct simulation values', ->
        expectLastSimulationValues(expectedSimulationValues())

    context 'with a merged observable', ->
      props.is ->
        defaultObservable:
          factory: { type: 'timer', args: [1000, ''] }
          operators: [
            {
              type: 'merge'
              args: [
                {
                  observable:
                    factory: { type: 'timer', args: [1000, ''] }
                    operators: []
                }
              ]
            }
          ]
      expectedSimulationValues.is -> [1001, '0C', '0C', '00C']

      it 'has correct simulation values', ->
        expectLastSimulationValues(expectedSimulationValues())

      context 'when changing on the arguments', ->
        beforeEach ->
          changeArgument('r', 0, 500)
        expectedSimulationValues.is -> [1001, '', '0C', '0C']

        it 'changes the simulation values immediately', ->
          expectLastSimulationValues(expectedSimulationValues())

    context 'with a flatmapped observable', ->
      props.is ->
        defaultObservable:
          factory: { type: 'timer', args: [1000, ''] }
          operators: [
            {
              type: 'flatMap'
              args: [
                {
                  functionDeclaration: 'function(x){ return'
                  observable:
                    {
                      factory: { type: 'of', args: ['x, x + 5'] }
                      operators: []
                    }
                }
              ]
            }
          ]

      expectedSimulationValues.is -> [1001, '0C', '05C', '05C']

      it 'has correct simulation values', ->
        expectLastSimulationValues(expectedSimulationValues())
