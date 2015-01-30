messageDisplayer = ->
  onTime = (time, cb) ->
    setTimeout cb, 200 + time

  append: (key, resultType, value) ->
    $("##{key} .simulationArea .#{resultType}")
      .append("<span>#{JSON.stringify(value)} </span>")

  value: (key, time, value) ->
    onTime time, => @append(key, "value", value)

  error: (key, time, error) ->
    onTime time, => @append(key, "error", error)

  complete: (key, time) ->
    onTime time, => @append(key, "complete", "C")

resultDisplayer = (messageDisplayer) ->
  sortResults: R.compose(R.sortBy(R.length), R.keys)
  display: (results) ->
    @clear()
    for key in @sortResults(results)
      result = results[key]
      for message in result.messages
        switch message.value.kind
          when "N" then messageDisplayer.value(key, message.time, message.value.value)
          when "E" then messageDisplayer.error(key, message.time, message.value.error)
          when "C" then messageDisplayer.complete(key, message.time)
  clear: ->
    $(".simulationArea .error").html("")
    $(".simulationArea .value").html("")
    $(".simulationArea .complete").html("")

displayer = resultDisplayer(messageDisplayer())

Visualizer.displayResults = displayer.display.bind(displayer)

