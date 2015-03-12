require '../test_helper'
global.Flux = require 'flux'
global.Rx = require 'rx'
global.EventEmitter = require('events').EventEmitter
memo = require 'memo-is'
require '../../assets/javascripts/react/dispatcher/dispatcher.coffee'
require '../../assets/javascripts/react/stores/base_store.coffee'
require '../../assets/javascripts/react/stores/notification_store.coffee'
V = Visualizer
store = V.notificationStore

onNext = Rx.ReactiveTest.onNext
onCompleted = Rx.ReactiveTest.onNext

describe 'NotificationStore', ->
  notifications = memo().is -> {}
  describe 'mapInRelevantTimes', ->
    beforeEach ->
      @subject = ->
        store.filterRelevant(
          store.countTimes(notifications())
        )(notifications())

    context 'when all have values at the same time', ->
      notifications.is ->
          a: [onNext(200), onNext(250)]
          b: [onNext(200), onNext(250)]

      it 'has the correct values and counts', ->
        expect(@subject()).toEqual
          a:
            200:
              values: [ onNext(200) ]
              count: 1
            250:
              values: [ onNext(250) ]
              count: 1
          b:
            200:
              values: [ onNext(200) ]
              count: 1
            250:
              values: [ onNext(250) ]
              count: 1

    context 'when values are with delay', ->
      notifications.is ->
          a: [onNext(200)]
          b: [onNext(230)]

      it 'has the correct values and counts', ->
        expect(@subject()).toEqual
          a:
            200:
              values: [ onNext(200) ]
              count: 1
            230:
              values: []
              count: 1
          b:
            200:
              values: []
              count: 1
            230:
              values: [ onNext(230) ]
              count: 1

    context 'when one has multiple values when others have on', ->
      notifications.is ->
        a: [onNext(200), onNext(250)]
        b: [onNext(230), onNext(250)]
        c: [onNext(200), onNext(230), onNext(250), onNext(250)]

      it 'fills empty spaces and spaces with multiple values', ->
        expect(@subject()).toEqual
          a:
            200:
              values: [ onNext(200) ]
              count: 1
            230:
              values: []
              count: 1
            250:
              values: [ onNext(250) ]
              count: 2
          b:
            200:
              values: []
              count: 1
            230:
              values: [ onNext(230) ]
              count: 1
            250:
              values: [ onNext(250) ]
              count: 2
          c:
            200:
              values: [ onNext(200) ]
              count: 1
            230:
              values: [ onNext(230) ]
              count: 1
            250:
              values: [ onNext(250), onNext(250) ]
              count: 2

