messageDisplayer = ->
  onTime = (time, cb) ->
    setTimeout cb, 200 + time

  value: (key, time, value) ->
    onTime time, ->
      $("##{key} .simulationArea .value").html(JSON.stringify(value))

  error: (key, time, error) ->
    onTime time, ->
      $("##{key} .simulationArea .error").html(JSON.stringify(error))

  complete: (key, time) ->
    onTime time, ->
      $("##{key} .simulationArea .complete").html("C")

resultDisplayer = (messageDisplayer) ->
  display: (results) ->
    @clear()
    for key, result of results
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

