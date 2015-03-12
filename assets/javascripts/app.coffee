Rx = require 'rx'
R = require 'ramda'
React = require 'react'
$ = require 'jquery'

NotificationActions = require './react/actions/notification_actions'
BuildArea = require './react/components/build_area'
Persister = require './persistency/persister'

buildObservable    = require './builder/builder'
evaluateObservable = require './factory/factory'
simulateObservable = require './simulator/simulator'

Rx.Observable.fromTime = (timesAndValues, scheduler) ->
  timers = R.keys(timesAndValues)
    .map (relativeTime) -> [parseInt(relativeTime), timesAndValues[relativeTime]]
    .map ([time, value]) ->
      Rx.Observable.timer(time, scheduler).map R.I(value)

  Rx.Observable.merge(timers)

defaultStructure = {
  root:
    type: 'fromTime', args: "{1000: 1, 3000: 2, 5000: 3}"
  operators: [ { type: 'map' } ]
}

renderBuildArea = ->
  observableSubject = new Rx.Subject

  startingStructure = Persister.load() || defaultStructure

  buildArea = <BuildArea defaultObservable={startingStructure}
    onChange={observableSubject.onNext.bind(observableSubject)} />
  renderedBuildArea = React.render(buildArea, document.getElementById('content'))

  observableFromUI = observableSubject.startWith startingStructure

  {observableFromUI, renderedBuildArea}


$(document).ready ->
  {observableFromUI, renderedBuildArea} = renderBuildArea()

  observableStructure = Rx.Observable.merge([
    Rx.Observable.fromEvent($("#load"), 'click').map Persister.load
    Rx.Observable.fromEvent($("#clear"), 'click').map R.always(defaultStructure)
  ])

  observableStructure
    .map (structure) -> observable: structure
    .subscribe renderedBuildArea.setState.bind(renderedBuildArea)

  collectedResults =
    Rx.Observable.fromEvent($("#analyze"), 'click')
      .withLatestFrom(observableFromUI, R.nthArg(1))
      .map (obs) ->
        R.compose(simulateObservable, evaluateObservable, buildObservable)(obs)
      .share()

  collectedResults.subscribe NotificationActions.setNotifications

  Rx.Observable.fromEvent($("#play"), 'click')
    .withLatestFrom(collectedResults, R.nthArg(1))
    .subscribe NotificationActions.playVirtualTime

  Rx.Observable.fromEvent($("#save"), 'click')
    .withLatestFrom(observableFromUI, R.nthArg(1))
    .subscribe R.compose(Persister.save)

  Rx.Observable.fromEvent($("#clear"), 'click').subscribe Persister.clear

  $("#analyze").click()

