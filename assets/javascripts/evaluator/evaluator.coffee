V = Visualizer
N = V.ReactNodes

getArgsWithScheduler = ({input, getDefaultArgs, useScheduler}) ->
  if getDefaultArgs && useScheduler
    "#{input}, scheduler"
  else if useScheduler
    "scheduler"
  else if getDefaultArgs
    input
  else
    ""

rootEvaluators = R.mapObjIndexed( ({useScheduler, getDefaultArgs}, key) ->
  (input) ->
    R.always(
      "Rx.Observable.#{key}(" +
      getArgsWithScheduler({input, useScheduler, getDefaultArgs}) +
      ")"
    )
  )(V.Roots)

operatorEvaluators = R.mapObjIndexed( ({useScheduler, recursive, getDefaultArgs, recursionType}, key) ->
  (input) ->
    if recursive
      (innerObservable) ->
        switch recursionType
          when "function" then ".#{key}(#{input}#{innerObservable}})"
          when "observable" then ".#{key}(#{innerObservable})"
          when "observableWithSelector" then ".#{key}(#{innerObservable}, #{input})"
    else
      R.always(
        ".#{key}(#{getArgsWithScheduler({input, useScheduler, getDefaultArgs})})"
      )
  )(V.Operators)

evalRoot = ({id, type, args}) ->
  getCode: rootEvaluators[type](args)
  id: id

evalOperator = ({id, type, args, observable}) ->
  id: id
  getCode: operatorEvaluators[type](args)
  observable: observable && V.buildCode(observable)

V.buildCode = ({root, operators}) ->
  root: evalRoot(root)
  operators: operators.map evalOperator
