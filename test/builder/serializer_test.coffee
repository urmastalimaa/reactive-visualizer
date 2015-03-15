require '../test_helper'
R = require 'ramda'

serialize = require '../../assets/javascripts/builder/serializer'

describe 'serialize', ->
  observable = memo().is -> {}

  subject = ->
    serialize(observable())

  context 'simple map', ->
    observable.is ->
      root:
        type: 'just'
        args: [ R.always('5') ]
      operators: [
        type: 'map'
        args: [ R.always('function(x) { return x; }') ]
      ]

    it 'serializes correctly', ->
      expect(subject()).toEqual
        root:
          type: 'just'
          id: 'r'
          args: ['5']
        operators: [
          type: 'map'
          id: 'ro'
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

  context 'merge', ->
    observable.is ->
      root:
        type: 'just'
        args: [ R.always('5') ]
      operators: [
        {
          type: 'merge'
          args: [
            R.always(
              root:
                type: 'of'
                args: [ R.always('1,2') ]
              operators: []
            )
          ]
        }
      ]

    it 'serialize correctly', ->
      expect(subject()).toEqual
        root:
          type: 'just'
          id: 'r'
          args: ['5']
        operators: [
          type: 'merge'
          id: 'ro'
          args: [
            root:
              type: 'of'
              id: 'ro0r'
              args: ['1,2']
            operators: []
          ]
        ]

  context 'combineLatest', ->
    observable.is ->
      root:
        type: 'just'
        args: [ R.always('5') ]
      operators: [
        {
          type: 'combineLatest'
          args: [
            R.always(
              root:
                type: 'timer'
                args: [ R.always(1000) ]
              operators: []
            )
            R.always('function(a,b) { return a + b; }')
          ]
        }
      ]

    it 'serialize correctly', ->
      expect(subject()).toEqual {
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
                args: [1000]
              operators: []
            },
            'function(a,b) { return a + b; }'
          ]
        ]
      }
