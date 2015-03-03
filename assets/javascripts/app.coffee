window.Visualizer = V = {}

V.ReactNodes = Nodes = {}
Nodes.Operators = {}
Nodes.Roots = {}

defaultStructure = {
  root:
    type: 'fromTime', id: 'r'
  operators: [
    {type: 'map', id: 'ro'}
    {type: 'delay', id: 'roo'}
    {type: 'filter', id: 'rooo'}
    {type: 'bufferWithTime', id: 'roooo'}
    {type: 'flatMap', id: 'rooooo', observable:
      root:
        type: 'of', id: 'rooooor'
      operators: [
        {type: 'map', id: 'roooooro'}
      ]
    }
  ]
}

uiValuator =
  textArea: (id) ->
    $("##{id} textarea").val()

$(document).ready ->
  observableFromUI = new Rx.Subject

  buildArea = <V.BuildArea defaultObservable={defaultStructure} onChange={observableFromUI.onNext.bind(observableFromUI)} />
  React.render(buildArea, document.getElementById('content'))

  Rx.Observable.fromEvent($("#start"), 'click')
    .withLatestFrom(observableFromUI.startWith(defaultStructure), (_, observable) -> observable)
    .subscribe (struc) ->
      console.log "shaka", struc
      R.compose(V.displayResults, V.simulateObservable, V.buildObservable(uiValuator, {}))(struc)

  setTimeout ->
    $("#start").click()
  , 100

