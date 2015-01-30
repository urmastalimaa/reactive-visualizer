runObservables = (observableFactories) ->
  console.log "running observables", observableFactories
  R.foldl((map, key) ->
    scheduler = new Rx.TestScheduler
    results = scheduler.startWithTiming ->
      observableFactories[key](scheduler)
    , 0, 0, 100000

    R.assoc(key, results, map)
  )({}, R.keys(observableFactories))

Visualizer.simulateObservable = runObservables
