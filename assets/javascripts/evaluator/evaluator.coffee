V = Visualizer
N = V.ReactNodes

inputVal = (id) ->
  $("##{id} > textarea").val()

rootEvaluators = R.mapObjIndexed( ({useScheduler, defaultArgs}, key) ->
  (input) ->
    "Rx.Observable.#{key}(" +
      (if defaultArgs then input else '') +
      (if useScheduler then (if defaultArgs then ', scheduler)' else 'scheduler)') else ')')
  )(N.Roots)

operatorEvaluators = R.mapObjIndexed( ({useScheduler, recursive, defaultArgs}, key) ->
  (input) ->
    ".#{key}(" +
      (if defaultArgs then input else '') +
      (if recursive then '' else (if useScheduler then ', scheduler)' else ')'))
  )(N.Operators)

evalRoot = (root) ->
  args = inputVal(root.id)
  R.mixin root,
    args: args
    code: rootEvaluators[root.type](args)

evalOperator = (operator) ->
  args = inputVal(operator.id)
  if operator.observable
    innerObs = V.evaluateInput(operator.observable)
    R.mixin operator,
      args: args
      code: operatorEvaluators[operator.type](args)
      observable: innerObs
  else
    R.mixin operator,
      args: args
      code: operatorEvaluators[operator.type](args)

V.evaluateInput = ({root, operators}) ->
  root: evalRoot(root)
  operators: operators.map evalOperator

