module.exports =
  save: (observable) ->
    localStorage.savedObservable = JSON.stringify(observable)

  load: ->
    try
      JSON.parse(localStorage.savedObservable)
    catch error
      null

  clear:->
    delete localStorage['savedObservable']
