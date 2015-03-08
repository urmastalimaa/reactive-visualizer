V = Visualizer
N = V.ReactNodes

rootEvaluators = R.mapObjIndexed( ({useScheduler, getDefaultArgs}, key) ->
  (input) ->
    R.always(
      "Rx.Observable.#{key}(" +
        (if getDefaultArgs then input else '') +
        (if useScheduler then (if getDefaultArgs then ', scheduler)' else 'scheduler)') else ')')
    )
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
      R.always(".#{key}(#{input || ''}#{useScheduler && ', scheduler' || ''})")
  )(N.Operators)

evalRoot = ({id, type, args}) ->
  getCode: rootEvaluators[type](args)
  id: id

evalOperator = ({id, type, args, observable}) ->
  id: id
  getCode: operatorEvaluators[type](args)
  observable: observable && V.evaluateInput(observable)

V.evaluateInput = ({root, operators}) ->
  root: evalRoot(root)
  operators: operators.map evalOperator

