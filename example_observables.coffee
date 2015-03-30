module.exports = [
  {
    name: 'simpleMap'
    description: 'The squares of a few values over time'
    observable:
      root:
        type: 'fromTime'
        args: [ "{1000: 1, 3000: 2, 5000: 3}" ]
      operators: [
        {
          type: 'map'
          args: [ "function(x) { return x * x }" ]
        }
      ]
  }
  {
    name: 'mapAndTake'
    description: 'The squares of infinite values bounded by take'
    observable:
      root:
        type: 'interval', args: ["500"]
      operators: [
        { type: 'map', args: ["function(x) { return x * x }"] }
        { type: 'take', args: ["10"] }
      ]
  }
  {
    name: "raceCondition#1"
    description:
      "User requests page 1, changes his mind and requests page 2, receives wrong page"
    observable:
      root:
        type: 'fromTime', args: ["{1000: 1, 2000: 2}"]
      operators: [
        {
          type: 'flatMap'
          args: [
            {
              functionDeclaration: "function(productNr) { return "
              observable:
                root:
                  type: 'timer', args: ["(5 - productNr * 2) * 1000"]
                operators: [
                  { type: 'map', args: ["function(x) { return 'product ' + productNr }"] }
                ]
            }
          ]
        }
      ]
  }
  {
    name: "fixedRaceCondition#1"
    description: "Fix race condition #1 by mapping waiting for previous response before new request. The user gets the every requested page and has to wait"
    observable:
      root:
        type: 'fromTime', args: ["{1000: 1, 2000: 2}"]
      operators: [
        {
          type: 'concatMap'
          args: [
            {
              functionDeclaration: "function(productNr) { return "
              observable:
                root:
                  type: 'timer', args: ["(5 - productNr * 2) * 1000"]
                operators: [
                  { type: 'map', args: ["function(x) { return 'product ' + productNr }"] }
                ]
            }
          ]
        }
      ]
  }
  {
    name: "fixedRaceCondition#2"
    description: "Fix race condition #1 by flat mapping the latest request. The user gets the latest requested page immediately"
    observable:
      root:
        type: 'fromTime', args: ["{1000: 1, 2000: 2}"]
      operators: [
        {
          type: 'flatMapLatest'
          args: [
            {
              functionDeclaration: "function(productNr) { return "
              observable:
                root:
                  type: 'timer', args: ["(5 - productNr * 2) * 1000"]
                operators: [
                  { type: 'map', args: ["function(x) { return 'product ' + productNr }"] }
                ]
            }
          ]
        }
      ]
  }
  {
    name: "wrong flatMapLatest"
    description: "Using flatMapLatest is not correct when you want all the mapped results, in this case flatMap is preferred."
    observable:
      root:
        type: 'of', args: ["'question1', 'question2', 'question3'"]
      operators: [
        {
          type: 'flatMapLatest'
          args: [
            {
              functionDeclaration: "function(question) { return "
              observable:
                root:
                  type: 'timer', args: ["1000"]
                operators: [
                  { type: 'map', args: ["function(x) { return 'answer' + question[question.length - 1] }"] }
                ]
            }
          ]
        }
      ]
  }
  {
    name: 'delayWithSelector'
    description: "Every value takes progressively longer to process"
    observable:
      root:
        type: 'interval', args: ["500"]
      operators: [
        {
          type: 'delayWithSelector'
          args: [
            {
              functionDeclaration: "function(input) { return "
              observable:
                root:
                  type: 'timer', args: ["input * input * 500"]
                operators: [
                  {
                    type: 'timeout'
                    args: ["3000"]
                  }
                ]
            }
          ]
        }
        {
          type: 'takeUntilWithTime'
          args: ["6000"]
        }
      ]
  }
  {
    name: 'generateAndBuffer'
    description: "Values come later and later, buffer length changes"
    observable:
      root:
        type: 'generateWithRelativeTime',
        args: [
          1,
          "function(x) { return x <= 10 }"
          "function(x) { return x + 1 }"
          "function(x) { return x }"
          "function(x) { return 200 * x }"
        ]
      operators: [
        {
          type: 'bufferWithTimeOrCount'
          args: [ 2000, 3 ]
        }
      ]
  }
  {
    name: 'merge'
    description: 'Merge two unrelated observables'
    observable:
      root:
        type: 'timer'
        args: [ 1000 ]
      operators: [
        {
          type: 'merge'
          args: [
            observable:
              root:
                type: 'timer'
                args: [500]
              operators: []
          ]
        }
      ]

  }

]

