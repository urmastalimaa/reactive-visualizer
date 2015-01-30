window.Visualizer = V = {}

defaultStructure = {
  root:
    type: 'fromTime', id: 'r'
  operators: [
    {type: 'map', id: 'ro'}
    {type: 'delay', id: 'roo'}
    {type: 'filter', id: 'rooo'}
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
    .subscribe R.compose(V.displayResults, V.simulateObservable, V.buildObservable(uiValuator))

  $("#start").click()

