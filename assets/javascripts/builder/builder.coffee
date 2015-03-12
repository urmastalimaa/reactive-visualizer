R = require 'ramda'
Operators = require '../descriptors/operators'
Roots = require '../descriptors/roots'

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
  )(Roots)

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
  )(Operators)

evalRoot = ({id, type, args}) ->
  getCode: rootEvaluators[type](args)
  id: id

evalOperator = ({id, type, args, observable}) ->
  id: id
  getCode: operatorEvaluators[type](args)
  observable: observable && buildCode(observable)

buildCode = ({root, operators}) ->
  root: evalRoot(root)
  operators: operators.map evalOperator

module.exports = buildCode
