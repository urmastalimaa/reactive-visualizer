R = require 'ramda'

saveObservable = (observable) ->
  localStorage.savedObservable = JSON.stringify(observable)

loadObservable = ->
  try
    JSON.parse(localStorage.savedObservable)
  catch error
    null

saveExamples = (examples) ->
  console.log "saving", examples
  localStorage.examples = JSON.stringify(examples)
  examples

loadExamples = ->
  try
    JSON.parse(localStorage.examples) || []
  catch error
    []

module.exports =
  save: saveObservable
  load: loadObservable
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
