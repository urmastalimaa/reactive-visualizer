require '../test_helper'
R = require 'ramda'

build = require '../../assets/javascripts/builder/builder'

describe 'build', ->
  observable = memo().is ->
  operatorInspector = R.nthArg(1)
  subject = -> build(observable())(operatorInspector)

  context 'simple map', ->
    observable.is ->
      root:
        type: 'just'
        args: ['5']
      operators: [
        type: 'map'
        args: ['function(x) { return x; }']
      ]

    it 'builds correctly', ->
      expect(subject())
        .toEqual 'Rx.Observable.just(5).map(function(x) { return x; })'

  context 'flatMap', ->
    observable.is ->
      root:
        type: 'just'
        args: ['5']
      operators: [
        type: 'flatMap'
        args: [
          {
            functionDeclaration: 'function(arg1){ return'
            observable:
              root:
                type: 'just'
                args: ['4*arg1']
              operators: []
          }
        ]
      ]

    it 'builds correctly', ->
      expect(subject())
        .toEqual 'Rx.Observable.just(5).flatMap(function(arg1){ return Rx.Observable.just(4*arg1)})'

  context 'merge', ->
    observable.is ->
      root:
        type: 'just'
        args: ['5']
      operators: [
        type: 'merge'
        args: [
          {
            observable:
              root:
                type: 'of'
                args: ['1,2']
              operators: []
          }
        ]
      ]

    it 'builds correctly', ->
      expect(subject())
        .toEqual 'Rx.Observable.just(5).merge(Rx.Observable.of(1,2))'

  context 'combineLatest', ->
    observable.is ->
      root:
        type: 'just'
        args: ['5']

      operators: [
        type: 'combineLatest'
        args: [
          {
            observable:
              root:
                type: 'timer'
                args: [1000]
              operators: []
          },
          'function(a,b) { return a + b; }'
        ]
      ]

    it 'builds correctly', ->
      expect(subject())
        .toEqual 'Rx.Observable.just(5).combineLatest(Rx.Observable.timer(1000,null,scheduler),function(a,b) { return a + b; })'
