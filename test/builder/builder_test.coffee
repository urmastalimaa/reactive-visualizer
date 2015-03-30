require '../test_helper'
R = require 'ramda'

build = require '../../assets/javascripts/builder/builder'

describe 'build', ->
  serialized = memo().is ->
  operatorInspector = R.nthArg(1)
  subject = -> build(serialized())(operatorInspector)

  context 'simple map', ->
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

    it 'builds correctly', ->
      expect(subject())
        .toEqual 'Rx.Observable.just(5).map(function(x) { return x; })'

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

    it 'builds correctly', ->
      expect(subject())
        .toEqual 'Rx.Observable.just(5).flatMap(function(arg1){ return Rx.Observable.just(4*arg1)})'

  context 'merge', ->
    serialized.is ->
      root:
        type: 'just'
        id: 'r'
        args: ['5']
      operators: [
        type: 'merge'
        id: 'ro'
        args: [
          {
            observable:
              root:
                type: 'of'
                id: 'ro0r'
                args: ['1,2']
              operators: []
          }
        ]
      ]

    it 'builds correctly', ->
      expect(subject())
        .toEqual 'Rx.Observable.just(5).merge(Rx.Observable.of(1,2))'

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
            observable:
              root:
                type: 'timer'
                id: 'ro0r'
                args: [1000]
              operators: []
          },
          'function(a,b) { return a + b; }'
        ]
      ]

    it 'builds correctly', ->
      expect(subject())
        .toEqual 'Rx.Observable.just(5).combineLatest(Rx.Observable.timer(1000,null,scheduler),function(a,b) { return a + b; })'
