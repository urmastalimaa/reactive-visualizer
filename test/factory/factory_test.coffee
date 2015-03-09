require '../test_helper'
require '../../assets/javascripts/factory/factory'

onNext = Rx.ReactiveTest.onNext
onCompleted = Rx.ReactiveTest.onCompleted

describe 'evalObservable', ->
  uiValuator = textArea: (id) -> uiValues()[id]

  subject = ->
    scheduler = new Rx.TestScheduler
    observableFactory = Visualizer.evalObservable(uiValuator, {})(structure())

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

    it 'has correct values', ->
      expect(subject()).toEqual [
        onNext(200, 1)
        onCompleted(200)
      ]

  context 'single operator', ->
    rootType = memo().is -> 'of'
    root = memo().is -> type: rootType(), id: 'rootId'

    structure.is ->
      root: root()
      operators: [type: type(), id: 'opId']

    targetId.is -> 'opId'
    uiValues.is ->
      rootId: rootValue()
      opId: opValue()

    type = memo().is ->
    rootValue = memo().is ->
    opValue = memo().is ->

    context 'map', ->
      type.is -> 'map'
      rootValue.is -> '1,2,3'
      opValue.is -> 'function(value) { return value * value }'

      it 'has correct values', ->
        expect(subject()).toEqual [
          onNext(200, 1)
          onNext(200, 4)
          onNext(200, 9)
          onCompleted(200)
        ]

    context 'filter', ->
      type.is -> 'filter'
      rootValue.is -> '2,5,9,10'
      opValue.is -> 'function(value) { return value % 2 == 0 }'

      it 'has correct values', ->
        expect(subject()).toEqual [
          onNext(200, 2)
          onNext(200, 10)
          onCompleted(200)
        ]

    context 'delay', ->
      type.is -> 'delay'
      rootValue.is -> '1,2'
      opValue.is -> '100'

      it 'has correct values', ->
        expect(subject()).toEqual [
          onNext(300, 1)
          onNext(300, 2)
          onCompleted(300, 100)
        ]

    context 'bufferWithTime', ->
      type.is -> "bufferWithTime"
      rootType.is -> 'fromTime'
      rootValue.is -> '{50: 1, 90: 2, 100: 3, 201: 4, 205: 5}'
      opValue.is -> '100'

      it 'has correct values', ->
        expect(subject()).toEqual [
          onNext(300, [1,2])
          onNext(400, [3])
          onNext(405, [4,5])
          onCompleted(405)
        ]

    context.only 'flatMap', ->
      structure.is ->
        root:
          type: 'of', id: 'rootId'
        operators: [
          {
            type: 'flatMap'
            id: 'flatMapId'
            observable:
              root:
                type: 'of', id: 'secondRootId'
              operators: [
                { type: 'map', id: 'mapId' }
              ]
          }
        ]

      uiValues.is ->
        rootId: '1,2,3'
        flatMapId: 'function(topValue)'
        secondRootId: "parseInt('1' + topValue)"
        mapId: 'function(value) { return value * value }'

      targetId.is -> 'mapId'

      it 'has correct values', ->
        console.log subject()

