V = Visualizer
N = V.ReactNodes

valFromTextArea = (id) ->
  $("##{id} textarea").val()

rootEvaluators = R.mapObjIndexed( ({useScheduler}, key) ->
  (input) ->
    "Rx.Observable.#{key}(#{input}#{if useScheduler then ', scheduler' else ''})"
  )(N.Roots)

operatorEvaluators =
  map:            (input) -> ".map(#{input})"
  filter:         (input) -> ".filter(#{input})"
  delay:          (input) -> ".delay(#{input}, scheduler)"
  take:           (input) -> ".take(#{input})"
  bufferWithTime: (input) -> ".bufferWithTime(#{input}, scheduler)"
  flatMap:        (input) -> ".flatMap(#{input}"
  merge:          (input) -> ".merge("

evalRoot = ({id, type}) ->
  args = (valFromTextArea(id))
  code: rootEvaluators[type](args)
  args: args
  id: id
  type: type

evalOperator = ({id, type, observable, recursionType}) ->
  args = (valFromTextArea(id))
  if observable
    val = (valFromTextArea(id))
    innerObs = Visualizer.evaluateInput(observable)

    code: operatorEvaluators[type](args)
    args: args
    id: id
    type: type
    observable: innerObs
    recursionType: recursionType
  else
    code: operatorEvaluators[type](args)
    args: args
    type: type
    id: id

V.evaluateInput = ({root, operators}) ->
  root: evalRoot(root)
  operators: operators.map evalOperator

