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
    type: 'fromTime', id: 'r', args: "{1000: 1, 3000: 2}"
  operators: [
    {
      type: 'flatMap'
      id: 'ro'
      args: 'function(outerValue) { return '
      observable:
        root:
          type: 'of', id: 'ror', args: "outerValue, parseInt('' + outerValue + outerValue)"
        operators: [
          {
            type: 'map'
            id: 'roro'
            args: 'function(value) { return value * outerValue; }'
          }
          {
            type: 'flatMap'
            id: 'roroo'
            observable:
              root:
                id: 'roroor'
                type: 'of'
                args: 'outerValue2, outerValue2 + 5'
              operators: []
          }
        ]
    }
    {
      type: 'take',
      id: 'roo'
      args: '6'
    }
  ]
}

$(document).ready ->
  observableFromUI = new Rx.Subject

  buildArea = <V.BuildArea defaultObservable={defaultStructure} onChange={observableFromUI.onNext.bind(observableFromUI)} />
  React.render(buildArea, document.getElementById('content'))

  runObservable = R.compose(V.displayResults, V.simulateObservable, V.buildObservable, V.evaluateInput)

  saveObservable = (observable) ->
    # need to evalute args to save
    localStorage.savedObservable = JSON.stringify(observable)

  loadObservable = ->
    try
      console.log "parsing", localStorage.savedObservable
      JSON.parse(localStorage.savedObservable)
    catch error
      ""

  observableToEvaluate = observableFromUI.startWith(loadObservable() || defaultStructure)

  Rx.Observable.fromEvent($("#start"), 'click')
    .withLatestFrom(observableToEvaluate, R.nthArg(1))
    .subscribe runObservable

  Rx.Observable.fromEvent($("#save"), 'click')
    .withLatestFrom(observableToEvaluate, R.nthArg(1))
    .subscribe saveObservable


  setTimeout ->
    $("#start").click()
  , 100

