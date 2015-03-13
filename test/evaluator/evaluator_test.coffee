require '../test_helper'

buildCode = require '../../assets/javascripts/builder/builder'

describe 'buildCode', ->
  structure = memo().is -> {}

  context 'only root', ->
    subject = -> buildCode(structure()).root.getCode()
    root = memo().is ->
    structure.is ->
      root: root()
      operators: []

    context 'without scheduler', ->
      root.is -> type: 'of', args: '1,2,3'

      it 'creates correct code', ->
        expect(subject()).toEqual 'Rx.Observable.of(1,2,3)'

    context 'with scheduler', ->
      root.is -> type: 'timer', args: '100'
      it 'creates correct code', ->
        expect(subject()).toEqual 'Rx.Observable.timer(100, scheduler)'

  context 'non-recursive operator', ->
    subject = -> buildCode(structure()).operators[0].getCode()
    structure.is ->
      root: type: 'interval', args: '100'
      operators: [operator()]
    operator = memo().is ->

    context 'without scheduler', ->
      operator.is -> type: 'take', args: '3'
      it 'creates correct code', ->
        expect(subject()).toEqual '.take(3)'

    context 'with scheduler', ->
      operator.is -> type: 'delay', args: '50'
      it 'creates correct code', ->
        expect(subject()).toEqual '.delay(50, scheduler)'

  context 'recursive function operator', ->
    subject = ->
      buildCode(structure()).operators[0].getCode("Rx.Observable.just(x)")

    structure.is ->
      root: type: 'interval', args: '100'
      operators: [
        {
          type: 'flatMap'
          args: 'function(x){ return '
          observable:
            root: type: 'just', args: 'x'
            operators: []
        }
      ]
    it 'creates correct code', ->
      expect(subject())
        .toEqual ".flatMap(function(x){ return Rx.Observable.just(x)})"

  context 'recursive observable operator', ->
    subject = ->
      buildCode(structure()).operators[0].getCode("Rx.Observable.just(5)")

    structure.is ->
      root: type: 'interval', args: '100'
      operators: [
        {
          type: 'merge'
          observable:
            root: type: 'just', args: '5'
            operators: []
        }
      ]

    it 'creates correct code', ->
      expect(subject())
        .toEqual ".merge(Rx.Observable.just(5))"

  context 'recursive observable with selector operator', ->
    subject = ->
      buildCode(structure()).operators[0].getCode("Rx.Observable.just(5)")

    structure.is ->
      root: type: 'interval', args: '100'
      operators: [
        {
          type: 'combineLatest'
          args: 'function(a, b){ return {a: a, b: b}; }'
          observable:
            root: type: 'just', args: '5'
            operators: []
        }
      ]

    it 'creates correct code', ->
      expect(subject())
        .toEqual ".combineLatest(Rx.Observable.just(5), function(a, b){ return {a: a, b: b}; })"

