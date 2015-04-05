R = require 'ramda'

saveObservable = R.tap (observable) ->
  localStorage.savedObservable = JSON.stringify(observable)

loadObservable = ->
  try
    JSON.parse(localStorage.savedObservable)
  catch error
    null

saveExamples = R.tap (examples) ->
  localStorage.examples = JSON.stringify(examples)

loadExamples = ->
  try
    JSON.parse(localStorage.examples) || []
  catch error
    []

clearObservable = ->
  saveObservable(null)

module.exports =
  save: saveObservable
  load: loadObservable
  clear: clearObservable
  allExamples: loadExamples

  addExample:
    R.compose(
      saveExamples
      R.useWith(R.append, R.identity, loadExamples)(R.__, null)
    )

  removeExample:
    R.compose(
      saveExamples
      R.useWith(R.reject, R.eqDeep, loadExamples)(R.__, null)
    )

  clearExamples:
    R.useWith(saveExamples, R.always([]))
