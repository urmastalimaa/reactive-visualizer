require '../test_helper'
R = require 'ramda'

identify = require '../../assets/javascripts/identifier'

describe 'identify', ->
  observable = memo().is ->
  operatorInspector = R.nthArg(1)
  subject = -> identify(observable())

  context 'simple map', ->
    observable.is ->
      factory:
        type: 'just'
        args: ['5']
      operators: [
        type: 'map'
        args: ['function(x) { return x; }']
      ]

    it 'builds correctly', ->
      expect(subject()).toEqual
        factory:
          id: 'f'
          type: 'just'
          args: ['5']
        operators: [
          id: 'fo'
          type: 'map'
          args: ['function(x) { return x; }']
        ]

  context 'flatMap', ->
    observable.is ->
      factory:
        type: 'just'
        args: ['5']
      operators: [
        type: 'flatMap'
        args: [
          {
            functionDeclaration: 'function(arg1){ return'
            observable:
              factory:
                type: 'just'
                args: ['4*arg1']
              operators: []
          }
        ]
      ]

    it 'builds correctly', ->
      expect(subject()).toEqual
        factory:
          id: 'f'
          type: 'just'
          args: ['5']
        operators: [
          id: 'fo'
          type: 'flatMap'
          args: [
            {
              functionDeclaration: 'function(arg1){ return'
              observable:
                factory:
                  id: 'fo0f'
                  type: 'just'
                  args: ['4*arg1']
                operators: []
            }
          ]
        ]

  context 'merge', ->
    observable.is ->
      factory:
        type: 'just'
        args: ['5']
      operators: [
        type: 'merge'
        args: [
          {
            observable:
              factory:
                type: 'of'
                args: ['1,2']
              operators: []
          }
        ]
      ]

    it 'builds correctly', ->
      expect(subject()).toEqual
        factory:
          id: 'f'
          type: 'just'
          args: ['5']
        operators: [
          id: 'fo'
          type: 'merge'
          args: [
            {
              observable:
                factory:
                  id: 'fo0f'
                  type: 'of'
                  args: ['1,2']
                operators: []
            }
          ]
        ]

  context 'combineLatest', ->
    observable.is ->
      factory:
        type: 'just'
        args: ['5']

      operators: [
        type: 'combineLatest'
        args: [
          {
            observable:
              factory:
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
        factory:
          id: 'f'
          type: 'just'
          args: ['5']

        operators: [
          id: 'fo'
          type: 'combineLatest'
          args: [
            {
              observable:
                factory:
                  id: 'fo0f'
                  type: 'timer'
                  args: [1000]
                operators: [
                  {
                    id: 'fo0fo'
                    type: 'take'
                    args: [4]
                  }
                ]
            },
            'function(a,b) { return a + b; }'
          ]
        ]
