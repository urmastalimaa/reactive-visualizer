Rx = require 'rx'
EventEmitter = require('events').EventEmitter

createObserver = ->
  Rx.Observer.create(
    (item) -> console.log(item)
    (error) -> console.log("error:", error, "\n")
    -> console.log("completed\n")
  )

Rx.Observable.just(5).subscribe(createObserver())
# 5
# completed

Rx.Observable.fromArray([1,2,3]).subscribe(createObserver())
# 1
# 2
# 3
# completed

Rx.Observable.range(1, 3).subscribe(createObserver())
# 1
# 2
# 3
# completed

emitter = new EventEmitter
Rx.Observable.fromEvent(emitter, 'event2').subscribe(createObserver())

emitter.emit('event1', 1)
emitter.emit('event2', 2)
# 2

Rx.Observable.throw(new Error("an error has occured")).subscribe(createObserver())
# error: [Error: an error has occured]

Rx.Observable.timer(500).subscribe(createObserver())

# 0 (after 500 ms)
# completed (after 500 ms)
