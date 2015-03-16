require '../test_helper'
Rx = require 'rx'
inspect = require '../../assets/javascripts/inspector/inspector'
build = require '../../assets/javascripts/builder/builder'
R = require 'ramda'

{onNext, onCompleted} = Rx.ReactiveTest

describe 'inspect', ->
  serialized = memo().is ->
  describe 'observable', ->
    subject = ->
      scheduler = new Rx.TestScheduler
      [observableFactory, collector] = inspect(build(serialized()))

      results = scheduler.startWithCreate R.always(observableFactory(scheduler))
      results.messages

    context 'simpleMap', ->
      serialized.is ->
        root:
          type: 'just'
          id: 'r'
          args: ['5']
        operators: [
          type: 'map'
          id: 'ro'
          args: ['function(x) { return x; }']
        ]

      it 'has correct values', ->
        expect(subject()).toEqual [
          onNext(200, 5)
          onCompleted(200)
        ]

    context 'flatMap', ->
      serialized.is ->
        root:
          type: 'just'
          id: 'r'
          args: ['5']
        operators: [
          type: 'flatMap'
          id: 'ro'
          args: [
            {
              functionDeclaration: 'function(arg1){ return'
              observable:
                root:
                  type: 'just'
                  id: 'ro0r'
                  args: ['4*arg1']
                operators: []
            }
          ]
        ]
      it 'has correct values', ->
        expect(subject()).toEqual [
          onNext(200, 20)
          onCompleted(200)
        ]

    context 'combineLatest', ->
      serialized.is ->
        root:
          type: 'just'
          id: 'r'
          args: ['5']

        operators: [
          type: 'combineLatest'
          id: 'ro'
          args: [
            {
              root:
                type: 'timer'
                id: 'ro0r'
                args: [100]
              operators: []
            },
            'function(a,b) { return a + b; }'
          ]
        ]

      it 'has correct values', ->
        expect(subject()).toEqual [
          onNext(300, 5)
          onCompleted(300)
        ]

    context 'non-recursive operators', ->
      operator = memo().is ->
      serialized.is ->
        root:
          type: 'of'
          id: 'r'
          args: ['1,2']
        operators: [operator()]

      context 'with argument, without scheduler', ->
        operator.is ->
          id: 'ro'
          type: 'map'
          args: ['function(x) { return x * 2 }']

        it 'has correct values', ->
          expect(subject()).toEqual [
            onNext(200, 2)
            onNext(200, 4)
            onCompleted(200)
          ]

      context 'with argument and scheduler', ->
        operator.is ->
          id: 'ro'
          type: 'delay'
          args: ['500']

        it 'has correct values', ->
          expect(subject()).toEqual [
            onNext(700, 1)
            onNext(700, 2)
            onCompleted(700)
          ]

    context 'with single recursive operator', ->
      serialized.is ->
        root:
          id: 'r'
          type: 'of'
          args: ['1, 2']
        operators: [operator()]

      operator = memo().is ->
        id: 'ro'
        type: 'flatMap'
        args: [
          functionDeclaration: 'function(x2){ return'
          observable: innerObservable()
        ]

      innerObservable = memo().is ->
        root:
          id: 'ro'
          type: 'of'
          args: ['x2, x2 * x2']
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
      serialized.is ->
        root:
          id: 'r'
          type: 'of'
          args: ['1,2']
        operators: [
          {
            id: 'ro'
            type: 'flatMap'
            args: [
              functionDeclaration: 'function(outerValue) { return'
              observable:
                root:
                  id: 'ror'
                  type: 'of'
                  args: ['outerValue, outerValue * outerValue']
                operators: [
                  id: 'roro'
                  type: 'delayWithSelector'
                  args: [
                    functionDeclaration: 'function(x){ return'
                    observable:
                      root:
                        id: 'roror'
                        type: 'timer'
                        args: ['x * 100']
                      operators: []
                  ]
                ]
            ]
          }
          {
            id: 'roo'
            type: 'skip'
            args: [1]
          }
        ]

      it 'has correct values', ->
        expect(subject()).toEqual [
          onNext(300, 1)
          onNext(400, 2)
          onNext(600, 4)
          onCompleted(600)
        ]

