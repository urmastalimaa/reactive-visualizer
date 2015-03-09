require '../test_helper'
require '../../assets/javascripts/factory/factory'

onNext = Rx.ReactiveTest.onNext
onCompleted = Rx.ReactiveTest.onCompleted
V = Visualizer

describe 'evalObservable', ->
  describe 'observable', ->
    subject = ->
      scheduler = new Rx.TestScheduler
      [observableFactory, collector] = V.evalObservable(structure())

      results = scheduler.startWithCreate R.always(observableFactory(scheduler))
      results.messages

    structure = memo().is ->

    context 'just a root', ->
      structure.is ->
        root:
          id: 'r', getCode: R.always('Rx.Observable.of(1)')
        operators: []

      it 'has correct values', ->
        expect(subject()).toEqual [
          onNext(200, 1)
          onCompleted(200)
        ]

    context 'single, non-recursive operator', ->
      operator = memo().is ->
      structure.is ->
        root: id: 'r', getCode: R.always('Rx.Observable.of(1, 2)')
        operators: [operator()]

      context 'without arguments', ->
        operator.is -> id: 'ro', getCode: R.always('.count()')

        it 'has correct values', ->
          expect(subject()).toEqual [
            onNext(200, 2)
            onCompleted(200)
          ]

      context 'with argument, without scheduler', ->
        operator.is -> id: 'ro', getCode: R.always('.map(function(x) { return x * 2 })')

        it 'has correct values', ->
          expect(subject()).toEqual [
            onNext(200, 2)
            onNext(200, 4)
            onCompleted(200)
          ]

      context 'with argument and scheduler', ->
        operator.is -> id: 'ro', getCode: R.always('.delay(500, scheduler)')

        it 'has correct values', ->
          expect(subject()).toEqual [
            onNext(700, 1)
            onNext(700, 2)
            onCompleted(700)
          ]

    context 'with single recursive operator', ->
      structure.is ->
        root: id: 'r', getCode: R.always('Rx.Observable.of(1, 2)')
        operators: [operator()]

      operator = memo().is ->
        id: 'ro'
        getCode: (innerObservable) -> ".flatMap(function(x) { return #{innerObservable} })"
        observable: innerObservable()

      innerObservable = memo().is ->
        root: id: 'ro', getCode: R.always('Rx.Observable.of(x, x * x)')
        operators: []


      it 'has correct values', ->
        expect(subject()).toEqual [
          onNext(200, 1)
          onNext(200, 1)
          onNext(200, 2)
          onNext(200, 4)
          onCompleted(200)
        ]

    context 'with complex observable', ->
      structure.is ->
        root: id: 'r', getCode: R.always('Rx.Observable.of(1, 2)')
        operators: [
          {
            id: 'ro'
            getCode: (innerObservable) ->
              ".flatMap(function(outerValue) { return #{innerObservable} })"
            observable:
              root: id: 'ror', getCode: R.always('Rx.Observable.of(outerValue, outerValue * outerValue)')
              operators: [
                id: 'roro', getCode: R.always('.delayWithSelector(function(x){ return Rx.Observable.timer(x * 100, scheduler) })')
              ]
          }
          {
            id: 'roo'
            getCode: R.always('.skip(1)')
          }
        ]

      it 'has correct values', ->
        expect(subject()).toEqual [
          onNext(300, 1)
          onNext(400, 2)
          onNext(600, 4)
          onCompleted(600)
        ]

  describe 'collector', ->
    subject = ->
      scheduler = new Rx.TestScheduler
      [observableFactory, collector] = V.evalObservable(structure())

      scheduler.startWithCreate R.always(observableFactory(scheduler))
      collector.results()

    structure = memo().is ->

    context 'with complex observable', ->
      structure.is ->
        root: id: 'r', getCode: R.always('Rx.Observable.ofWithScheduler(scheduler, 1, 2)')
        operators: [
          {
            id: 'ro'
            getCode: (innerObservable) ->
              ".flatMap(function(outerValue) { return #{innerObservable} })"
            observable:
              root: id: 'ror', getCode: R.always('Rx.Observable.ofWithScheduler(scheduler, outerValue, outerValue * outerValue)')
              operators: [
                 id: 'roro', getCode: R.always('.delayWithSelector(function(x){ return Rx.Observable.timer(x * 100, scheduler) })')
               ]
          }
        ]

      it 'stores results per id', ->
        # Weirdness in the time and order of messages is caused by the
        # virtual time scheduler

        expect(subject()).toEqual
          r:
            messages: [
              onNext(201, 1)
              onNext(202, 2)
              onCompleted(203)
            ]
          ro:
            messages: [
              onNext(302, 1)
              onNext(303, 1)
              onNext(403, 2)
              onNext(604, 4)
              onCompleted(604)
            ]
          ror:
            messages: [
              onNext(202, 1)
              onNext(203, 1)
              onNext(203, 2)
              onCompleted(204)
              onNext(204, 4)
              onCompleted(205)
            ]
          roro:
            messages: [
              onNext(302, 1)
              onNext(303, 1)
              onCompleted(303)
              onNext(403, 2)
              onNext(604, 4)
              onCompleted(604)
            ]
