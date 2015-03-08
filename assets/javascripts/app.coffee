window.Visualizer = V = {}

Rx.Observable.fromTime = (timesAndValues, scheduler) ->
  timers = R.keys(timesAndValues)
    .map (relativeTime) -> [parseInt(relativeTime), timesAndValues[relativeTime]]
    .map ([time, value]) ->
      Rx.Observable.timer(time, scheduler).map R.I(value)

  Rx.Observable.merge(timers)

V.ReactNodes = Nodes = {}
Nodes.Operators = {}
Nodes.Roots = {}

defaultStructure = {
  root:
    type: 'fromTime', id: 'r', args: "{1000: 1, 3000: 2, 5000: 3}"
  operators: [
    {
      type: 'map'
      id: 'ro'
      args: 'function(value) { return value * value; }'
    }
  ]
}

renderBuildArea = ->
  observableSubject = new Rx.Subject

  startingStructure = V.persistency.load() || defaultStructure

  buildArea = <V.BuildArea defaultObservable={startingStructure}
    onChange={observableSubject.onNext.bind(observableSubject)} />
  renderedBuildArea = React.render(buildArea, document.getElementById('content'))

  observableFromUI = observableSubject.startWith startingStructure
    .do (structure) ->
      console.log "new structure", structure
    .share()

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

  Rx.Observable.fromEvent($("#start"), 'click')
    .withLatestFrom(observableFromUI, R.nthArg(1))
    .subscribe R.compose(V.displayResults, V.simulateObservable, V.buildObservable, V.evaluateInput)

  Rx.Observable.fromEvent($("#save"), 'click')
    .withLatestFrom(observableFromUI, R.nthArg(1))
    .subscribe R.compose(V.persistency.save, V.evaluateInput)

  Rx.Observable.fromEvent($("#clear"), 'click').subscribe V.persistency.clear

  setTimeout ->
    $("#start").click()
  , 100

