mapMessages = R.mapObjIndexed((val, key) ->
  R.map(({time, key, value}) ->
    {time, key, value: value.value, exception: value.exception, kind: value.kind}
  )(R.map(R.assoc('key')(key))(R.get('messages')(val)))
)

analyze = R.compose(R.groupBy(R.get('time')), R.sortBy(R.get('time')), R.flatten, R.values, mapMessages)

Visualizer.analyzeResults = analyze
