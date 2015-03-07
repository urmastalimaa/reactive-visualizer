V = Visualizer
P = V.persistency = {}
P.save = (observable) ->
  localStorage.savedObservable = JSON.stringify(observable)

P.load = ->
  try
    JSON.parse(localStorage.savedObservable)
  catch error
    null

P.clear = ->
  delete localStorage['savedObservable']
