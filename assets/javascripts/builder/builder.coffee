R = require 'ramda'
Operators = require '../descriptors/operators'
Roots = require '../descriptors/roots'

getArgsWithScheduler = ({input, useScheduler}) ->
  R.join(',', if useScheduler then R.concat(input, ['scheduler']) else input)

rootEvaluators = R.mapObjIndexed( ({useScheduler}, key) ->
  (input) ->
    R.always(
      "Rx.Observable.#{key}(" +
      getArgsWithScheduler({input, useScheduler}) +
      ")"
    )
  )(Roots)

operatorEvaluators = R.mapObjIndexed( ({useScheduler, recursive, recursionType}, key) ->
  (input) ->
    if recursive
      (innerObservable) ->
        switch recursionType
          when "function" then ".#{key}(#{input}#{innerObservable}})"
          when "observable" then ".#{key}(#{innerObservable})"
          when "observableWithSelector" then ".#{key}(#{innerObservable}, #{input})"
    else
      R.always(
        ".#{key}(#{getArgsWithScheduler({input, useScheduler})})"
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
