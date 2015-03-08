V = Visualizer
N = V.ReactNodes

inputVal = (id) ->
  $("##{id} > textarea").val()

rootEvaluators = R.mapObjIndexed( ({useScheduler, getDefaultArgs}, key) ->
  (input) ->
    "Rx.Observable.#{key}(" +
      (if getDefaultArgs then input else '') +
      (if useScheduler then (if getDefaultArgs then ', scheduler)' else 'scheduler)') else ')')
  )(N.Roots)

operatorEvaluators = R.mapObjIndexed( ({useScheduler, recursive, getDefaultArgs, recursionType}, key) ->
  (input) ->
    if recursive
      (innerObservable) ->
        switch recursionType
          when "function" then ".#{key}(#{input}#{innerObservable}})"
          when "observable" then ".#{key}(#{innerObservable})"
          when "observableWithSelector" then ".#{key}(#{innerObservable}, #{input})"
    else
      ".#{key}(#{input || ''}#{useScheduler && ', scheduler' || ''})"
  )(N.Operators)

evalRoot = (root) ->
  args = inputVal(root.id)
  R.mixin root,
    args: args
    getCode: R.always(rootEvaluators[root.type](args))

evalOperator = (operator) ->
  args = inputVal(operator.id)
  if operator.observable
    innerObs = V.evaluateInput(operator.observable)
    R.mixin operator,
      args: args
      getCode: operatorEvaluators[operator.type](args)
      observable: innerObs
  else
    R.mixin operator,
      args: args
      getCode: R.always(operatorEvaluators[operator.type](args))

V.evaluateInput = ({root, operators}) ->
  root: evalRoot(root)
  operators: operators.map evalOperator

