require '../test_helper'
R = require 'ramda'

serialize = require('../../assets/javascripts/serializer').serializeObservable

describe 'serialize', ->
  observable = memo().is -> {}

  subject = ->
    serialize(0)(observable())

  context 'simple map', ->
    observable.is ->
      root:
        type: 'just'
        args: [R.always('5')]
      operators: [
        type: 'map'
        args: [R.always('function(x) { return x; }')]
      ]

    it 'serializes correctly', ->
      expect(subject()).toEqual
        root:
          type: 'just'
          args: ['5']
        operators: [
          type: 'map'
          args: ['function(x) { return x; }']
        ]

  context 'flatMap', ->
    observable.is ->
      root:
        type: 'just'
        args: ['5']
      operators: [
        type: 'flatMap'
        args: [
          {
            functionDeclaration: (recursionLevel) ->
              "function(arg#{recursionLevel}){ return"
            observable:
              root:
                type: 'just'
                args: [
                  R.compose(R.add('4*'), R.add('arg'))
                ]
              operators: []
          }
        ]
      ]

    it 'serializes correctly', ->
      expect(subject()).toEqual
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

  context 'merge', ->
    observable.is ->
      root:
        type: 'just'
        args: [ '5' ]
      operators: [
        {
          type: 'merge'
          args: [
            {
              observable:
                root:
                  type: 'of'
                  args: [ R.always('1,2') ]
                operators: []
            }
          ]
        }
      ]

    it 'serialize correctly', ->
      expect(subject()).toEqual
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

  context 'combineLatest', ->
    observable.is ->
      root:
        type: 'just'
        args: [ '5' ]
      operators: [
        {
          type: 'combineLatest'
          args: [
            {
              observable:
                root:
                  type: 'timer'
                  args: [ 1000 ]
                operators: [
                  {
                    type: 'take'
                    args: [R.always(4)]
                  }
                ]
            }
            'function(a,b) { return a + b; }'
          ]
        }
      ]

    it 'serialize correctly', ->
      expect(subject()).toEqual {
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
                operators: [
                  {
                    type: 'take'
                    args: [4]
                  }
                ]
            },
            'function(a,b) { return a + b; }'
          ]
        ]
      }
