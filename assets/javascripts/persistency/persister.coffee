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
      R.useWith(R.flip(R.append), loadExamples, R.I)(null)
    )

  removeExample:
    R.compose(
      saveExamples
      R.useWith(R.flip(R.reject), loadExamples, R.eqDeep)(null)
    )

  clearExamples:
    R.useWith(saveExamples, R.always([]))
