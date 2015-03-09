require '../test_helper'
require '../../assets/javascripts/displayer/display_analyzer'

V = Visualizer

describe.only 'analyzeResults', ->
  subject = memo().is -> V.analyzeResults(results())

  results = memo().is ->
    r:
      messages: [
        { time: 102, value: { kind: 'N', value: 1 } }
        { time: 202, value: { kind: 'N', value: 2 } }
        { time: 302, value: { kind: 'N', value: 3 } }
        { time: 302, value: { kind: 'C'} }
      ]
    ro:
      messages: [
        { time: 102, value: { kind: 'N', value: 1 } }
        { time: 202, value: { kind: 'N', value: 4 } }
        { time: 302, value: { kind: 'N', value: 9 } }
        { time: 302, value: { kind: 'C'} }
      ]

  it 'adds keys to notifications and sorts them', ->
    expect(subject()).toEqual
      102: [
        { time: 102, kind: 'N', value: 1, key: 'r', exception: undefined }
        { time: 102, kind: 'N', value: 1, key: 'ro', exception: undefined }
      ]
      202: [
        { time: 202, kind: 'N', value: 2, key: 'r', exception: undefined }
        { time: 202, kind: 'N', value: 4, key: 'ro', exception: undefined }
      ]
      302: [
        { time: 302, kind: 'N', value: 3, key: 'r', exception: undefined }
        { time: 302, kind: 'C', value: undefined, key: 'r', exception: undefined }
        { time: 302, kind: 'N', value: 9, key: 'ro', exception: undefined }
        { time: 302, kind: 'C', value: undefined, key: 'ro', exception: undefined }
      ]


