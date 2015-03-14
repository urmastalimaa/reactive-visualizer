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
    description: "Fix race condition #1 by mapping waiting for previous response before new request. The user get's the every requested page and has to wait"
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
    description: "Fix race condition #1 by flat mapping the latest request. The user get's the latest requested page immediately"
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
