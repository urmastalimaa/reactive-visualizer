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
onFiller = (time) ->
  {time, value: {kind: 'filler'}}



describe 'NotificationStore', ->
  notifications = memo().is -> {}
  describe 'mapInRelevantTimes', ->
    beforeEach ->
      @subject = ->
        store.fillAllNotifications(
          store.countTimes(notifications())
        )(notifications())

    context 'when all have values at the same time', ->
      notifications.is ->
          a: [onNext(200), onNext(250)]
          b: [onNext(200), onNext(250)]

      it 'is good', ->
        expect(@subject()).toEqual
          a: [ onNext(200), onNext(250) ]
          b: [ onNext(200), onNext(250) ]

    context 'when values are with delay', ->
      notifications.is ->
          a: [onNext(200), onNext(250)]
          b: [onNext(230), onNext(280)]

      it 'fills empty spaces', ->
        expect(@subject()).toEqual
          a: [ onNext(200), onFiller(230), onNext(250), onFiller(280) ]
          b: [ onFiller(200), onNext(230), onFiller(250), onNext(280) ]

    context 'when one has multiple values when others have on', ->
      notifications.is ->
        a: [onNext(200), onNext(250)]
        b: [onNext(230), onNext(250)]
        c: [onNext(200), onNext(230), onNext(250), onNext(250)]

      it 'fills empty spaces and spaces with multiple values', ->
        expect(@subject()).toEqual
          a: [onNext(200), onFiller(230), onFiller(250), onNext(250)]
          b: [onFiller(200), onNext(230), onFiller(250), onNext(250)]
          c: [onNext(200), onNext(230), onNext(250), onNext(250)]

  describe 'filterRelevant', ->
    currentTime = memo().is ->

    beforeEach ->
      @subject = ->
        filledNotifications = store.fillAllNotifications(
          store.countTimes(notifications())
        )(notifications())
        store.filterRelevant(currentTime())(filledNotifications)

    notifications.is ->
      a: [onNext(200), onNext(250)]
      b: [onNext(230), onNext(250)]
      c: [onNext(200), onNext(230), onNext(250), onNext(250)]

    context 'in the middle', ->
      currentTime.is -> 230

      it 'has only relevant values', ->
        expect(@subject()).toEqual
          a: [onNext(200), onFiller(230)]
          b: [onFiller(200), onNext(230)]
          c: [onNext(200), onNext(230)]

