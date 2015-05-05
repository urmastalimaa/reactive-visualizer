Rx = require 'rx'

createObserver = ->
  Rx.Observer.create(
    (item) -> console.log(item)
    (error) -> console.log("error:", error, "\n")
    -> console.log("completed\n")
  )

Rx.Observable.generate(
  0,
  (x) -> x < 10000000
  (x) -> x + 1
  (x) -> x
  Rx.Scheduler.immediate
 ).take(1)
  .subscribe(createObserver())
