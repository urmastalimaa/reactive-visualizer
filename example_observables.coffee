module.exports =
  simpleMap:
    description: 'The squares of a few values over time'
    root:
      type: 'fromTime', args: "{1000: 1, 3000: 2, 5000: 3}"
    operators: [ { type: 'map', args: 'function(x) { return x * x }' } ]

  mapAndTake:
    description: 'The squares of infinite values bounded by take'
    root:
      type: 'interval', args: "500"
    operators: [
      { type: 'map', args: 'function(x) { return x * x }' }
      { type: 'take', args: '10' }
    ]

  "raceCondition#1":
    description:
      "User requests page 1, changes his mind and requests page 2, receives wrong page"
    root:
      type: 'fromTime', args: "{1000: 1, 2000: 2}"
    operators: [
      {
        type: 'flatMap'
        args: 'function(productNr) { return '
        observable:
          root:
            type: 'timer', args: "(5 - productNr * 2) * 1000"
          operators: [
            { type: 'map', args: 'function(x) { return "product " + productNr }' }
          ]
      }
    ]

  "fixedRaceCondition#1":
    description: "Fix race condition #1 by mapping waiting for previous response before new request. The user gets the every requested page and has to wait"
    root:
      type: 'fromTime', args: "{1000: 1, 2000: 2}"
    operators: [
      {
        type: 'concatMap'
        args: 'function(productNr) { return '
        observable:
          root:
            type: 'timer', args: "(5 - productNr * 2) * 1000"
          operators: [
            { type: 'map', args: 'function(x) { return "product " + productNr }' }
          ]
      }
    ]
  "fixedRaceCondition#2":
    description: "Fix race condition #1 by flat mapping the latest request. The user gets the latest requested page immediately"
    root:
      type: 'fromTime', args: "{1000: 1, 2000: 2}"
    operators: [
      {
        type: 'flatMapLatest'
        args: 'function(productNr) { return '
        observable:
          root:
            type: 'timer', args: "(5 - productNr * 2) * 1000"
          operators: [
            { type: 'map', args: 'function(x) { return "product " + productNr }' }
          ]
      }
    ]
  "wrong flatMapLatest":
    description: "Using flatMapLatest is not correct when you want all the mapped results, in this case flatMap is preferred."
    root:
      type: 'of', args: "'question1', 'question2', 'question3'"
    operators: [
      {
        type: 'flatMapLatest'
        args: 'function(question) { return '
        observable:
          root:
            type: 'timer', args: "1000"
          operators: [
            { type: 'map', args: 'function(x) { return "answer" + question[question.length - 1] }' }
          ]
      }
    ]
  delayWithSelector:
    description: "Every value takes progressively longer to process"
    root:
      type: 'interval', args: '500'
    operators: [
      {
        type: 'delayWithSelector'
        args: 'function(input) { return '
        observable:
          root:
            type: 'timer', args: 'input * input * 500'
          operators: [
            {
              type: 'timeout'
              args: '3000'
            }
          ]
      }
      {
        type: 'takeUntilWithTime'
        args: '6000'
      }
    ]
