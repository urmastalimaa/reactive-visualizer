valFromTextArea = (id) ->
  $("##{id} textarea").val()

rootEvaluators =
  fromTime: (input) -> "Rx.Observable.fromTime(#{input}, scheduler)"
  of:       (input) -> "Rx.Observable.of(#{input})"

operatorEvaluators =
  map:            (input) -> ".map(#{input})"
  filter:         (input) -> ".filter(#{input})"
  delay:          (input) -> ".delay(#{input}, scheduler)"
  take:           (input) -> ".take(#{input})"
  bufferWithTime: (input) -> ".bufferWithTime(#{input}, scheduler)"
  flatMap:        (input) -> ".flatMap(#{input}"

evalRoot = ({id, type}) ->
  populated: rootEvaluators[type](valFromTextArea(id))
  id: id

evalOperator = ({id, type, observable}) ->
  if observable
    val = (valFromTextArea(id))
    innerObs = Visualizer.evaluateInput(observable)

    populated: operatorEvaluators[type](valFromTextArea(id))
    id: id
    observable: innerObs

  else
    populated: operatorEvaluators[type](valFromTextArea(id))
    id: id

Visualizer.evaluateInput = ({root, operators}) ->
  root: evalRoot(root)
  operators: operators.map evalOperator

