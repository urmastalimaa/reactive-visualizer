require '../test_helper'
require '../../assets/javascripts/factory/factory'

onNext = Rx.ReactiveTest.onNext
onCompleted = Rx.ReactiveTest.onCompleted

describe 'buildObservable', ->
  uiValuator = textArea: (id) -> uiValues()[id]

  subject = ->
    scheduler = new Rx.TestScheduler
    observableFactory = Visualizer.buildObservable(uiValuator)(structure())
    observable = observableFactory[targetId()](scheduler)
    results = scheduler.startWithCreate R.always(observable)
    results.messages

  uiValues = memo().is ->
  structure = memo().is ->
  targetId = memo().is ->

  context 'just of', ->
    structure.is ->
      root:
        type: 'of', id: 'rootId'
      operators: []

    uiValues.is -> rootId: '1'

    targetId.is -> 'rootId'

    it 'has the correct values', ->
      expect(subject()).toEqual [
        onNext(200, 1)
        onCompleted(200)
      ]

  context 'single operator', ->
    root = type: 'of', id: 'rootId'
    structure.is ->
      root: root
      operators: [type: type(), id: 'opId']
    targetId.is -> 'opId'
    uiValues.is ->
      rootId: ofValue()
      opId: opValue()

    type = memo().is ->
    ofValue = memo().is ->
    opValue = memo().is ->

    context 'map', ->
      type.is -> 'map'
      ofValue.is -> '1,2,3'
      opValue.is -> 'return value * value;'

      it 'is best', ->
        expect(subject()).toEqual [
          onNext(200, 1)
          onNext(200, 4)
          onNext(200, 9)
          onCompleted(200)
        ]

    context 'filter', ->
      type.is -> 'filter'
      ofValue.is -> '2,5,9,10'
      opValue.is -> 'return value % 2 == 0'

      it 'is best', ->
        expect(subject()).toEqual [
          onNext(200, 2)
          onNext(200, 10)
          onCompleted(200)
        ]

    context 'delay', ->
      type.is -> 'delay'
      ofValue.is -> '1,2'
      opValue.is -> '100'

      it 'has correct result', ->
        expect(subject()).toEqual [
          onNext(300, 1)
          onNext(300, 2)
          onCompleted(300, 100)
        ]
