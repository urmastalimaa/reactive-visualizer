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
  args = (valFromTextArea(id))
  code: rootEvaluators[type](args)
  args: args
  id: id
  type: type

evalOperator = ({id, type, observable}) ->
  args = (valFromTextArea(id))
  if observable
    val = (valFromTextArea(id))
    innerObs = Visualizer.evaluateInput(observable)

    code: operatorEvaluators[type](args)
    args: args
    id: id
    type: type
    observable: innerObs

  else
    code: operatorEvaluators[type](args)
    args: args
    type: type
    id: id

Visualizer.evaluateInput = ({root, operators}) ->
  root: evalRoot(root)
  operators: operators.map evalOperator

