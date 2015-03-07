messageDisplayer = ->
  onTime = (time, cb) ->
    setTimeout cb, 200 + time

  getTargetArea: (key, resultType) ->
    $("##{key} > .simulationArea .#{resultType}")


  append: (key, resultType, value) ->
    @getTargetArea(key, resultType)
      .append("<span>#{JSON.stringify(value)} </span>")

  set: (key, resultType, value) ->
    $el = @getTargetArea(key, resultType)
    $el.stop().show()
    $el.html("<span>#{JSON.stringify(value)} </span>")

  fadeOut: (key, resultType, time, fadeTargetTime) ->
    timeDifference = fadeTargetTime - time
    if timeDifference > 1000
      fadeDuration = 1000
      fadeTimeout = timeDifference - 1000
    else
      fadeDuration = timeDifference
      fadeTimeout = 0

    onTime time + fadeTimeout, =>
      $el = @getTargetArea(key, resultType)
      $el.fadeOut(fadeDuration - 100)

  value: (key, time, value) ->
    onTime time, => @set(key, "value", value)

  error: (key, time, error) ->
    onTime time, => @set(key, "error", error?.message || error)

  complete: (key, time) ->
    onTime time, => @set(key, "complete", "C")

resultDisplayer = (messageDisplayer) ->
  sortResults: R.compose(R.sortBy(R.length), R.keys)
  display: (results) ->
    @clear()
    for key in @sortResults(results)
      result = results[key]
      for message, index in result.messages
        switch message.value.kind
          when "N" then messageDisplayer.value(key, message.time, message.value.value)
          when "E" then messageDisplayer.error(key, message.time, message.value.exception || message.value.error)
          when "C" then messageDisplayer.complete(key, message.time)

        nextMessages = result.messages.slice(index + 1).filter (nextMessage) ->
          nextMessage.value.kind == message.value.kind

        unless nextMessages.length == 0
          type = switch message.value.kind
            when "N" then "value"
            when "E" then "error"
            when "C" then "complete"
          messageDisplayer.fadeOut(key, type, message.time, nextMessages[0].time)

  clear: ->
    $(".simulationArea .error").html("")
    $(".simulationArea .value").html("")
    $(".simulationArea .complete").html("")

displayer = resultDisplayer(messageDisplayer())

Visualizer.displayResults = displayer.display.bind(displayer)

