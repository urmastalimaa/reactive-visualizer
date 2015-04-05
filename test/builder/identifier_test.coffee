require '../test_helper'
R = require 'ramda'

identify = require '../../assets/javascripts/identifier'

describe 'identify', ->
  observable = memo().is ->
  operatorInspector = R.nthArg(1)
  subject = -> identify(observable())

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
      expect(subject()).toEqual
        root:
          id: 'r'
          type: 'just'
          args: ['5']
        operators: [
          id: 'ro'
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
      expect(subject()).toEqual
        root:
          id: 'r'
          type: 'just'
          args: ['5']
        operators: [
          id: 'ro'
          type: 'flatMap'
          args: [
            {
              functionDeclaration: 'function(arg1){ return'
              observable:
                root:
                  id: 'ro0r'
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
      expect(subject()).toEqual
        root:
          id: 'r'
          type: 'just'
          args: ['5']
        operators: [
          id: 'ro'
          type: 'merge'
          args: [
            {
              observable:
                root:
                  id: 'ro0r'
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

    it 'builds correctly', ->
      expect(subject()).toEqual
        root:
          id: 'r'
          type: 'just'
          args: ['5']

        operators: [
          id: 'ro'
          type: 'combineLatest'
          args: [
            {
              observable:
                root:
                  id: 'ro0r'
                  type: 'timer'
                  args: [1000]
                operators: [
                  {
                    id: 'ro0ro'
                    type: 'take'
                    args: [4]
                  }
                ]
            },
            'function(a,b) { return a + b; }'
          ]
        ]
