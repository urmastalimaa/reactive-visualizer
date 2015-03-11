window.Visualizer = V = {}

Rx.Observable.fromTime = (timesAndValues, scheduler) ->
  timers = R.keys(timesAndValues)
    .map (relativeTime) -> [parseInt(relativeTime), timesAndValues[relativeTime]]
    .map ([time, value]) ->
      Rx.Observable.timer(time, scheduler).map R.I(value)

  Rx.Observable.merge(timers)

V.ReactNodes = N = {}

defaultStructure = {
  root:
    type: 'fromTime', args: "{1000: 1, 3000: 2, 5000: 3}"
  operators: [ { type: 'map' } ]
}

renderBuildArea = ->
  observableSubject = new Rx.Subject

  startingStructure = V.persistency.load() || defaultStructure

  buildArea = <N.BuildArea defaultObservable={startingStructure}
    onChange={observableSubject.onNext.bind(observableSubject)} />
  renderedBuildArea = React.render(buildArea, document.getElementById('content'))

  observableFromUI = observableSubject.startWith startingStructure

  {observableFromUI, renderedBuildArea}


$(document).ready ->
  {observableFromUI, renderedBuildArea} = renderBuildArea()

  observableStructure = Rx.Observable.merge([
    Rx.Observable.fromEvent($("#load"), 'click').map V.persistency.load
    Rx.Observable.fromEvent($("#clear"), 'click').map R.always(defaultStructure)
  ])

  observableStructure
    .map (structure) -> observable: structure
    .subscribe renderedBuildArea.setState.bind(renderedBuildArea)

  collectedResults =
    Rx.Observable.fromEvent($("#analyze"), 'click')
      .withLatestFrom(observableFromUI, R.nthArg(1))
      .map (obs) ->
        R.compose(V.collectResults, V.evalObservable, V.buildCode)(obs)
      .share()

  collectedResults.subscribe V.setNotifications

  Rx.Observable.fromEvent($("#play"), 'click')
    .withLatestFrom(collectedResults, R.nthArg(1))
    .subscribe V.playVirtualTime

  Rx.Observable.fromEvent($("#save"), 'click')
    .withLatestFrom(observableFromUI, R.nthArg(1))
    .subscribe R.compose(V.persistency.save)

  Rx.Observable.fromEvent($("#clear"), 'click').subscribe V.persistency.clear

  setTimeout ->
    $("#analyze").click()
  , 100

