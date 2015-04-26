Rx = require 'rx'

createObserver = ->
  Rx.Observer.create(
    (item) -> console.log(item)
    (error) -> console.log("error:", error, "\n")
    -> console.log("completed\n")
  )

Rx.Observable.interval(300)
  .take(5)
  .debounce(500)
  .subscribe(createObserver())

# 4 (at 1500 ms)
# completed (at 1500 ms)

Rx.Observable.interval(300)
  .take(5)
  .sample(500)
  .subscribe(createObserver())

# 0 (at 300 ms)
# 2 (at 900 ms)
# 4 (at 1500 ms)
# completed (at 1500 ms)

Rx.Observable.interval(300)
  .take(5)
  .delay(200)
  .subscribe(createObserver())

# 0 (at 500 ms)
# 1 (at 800 ms)
# 2 (at 1100 ms)
# 3 (at 1400 ms)
# 4 (at 1700 ms)
# completed (at 1700 ms)

Rx.Observable.timer(1000)
  .timeout(800)
  .subscribe(createObserver())

# error: [Error: Timeout] (at 800 ms)

Rx.Observable.timer(500)
  .timeout(800)
  .subscribe(createObserver())

# 0 (at 500 ms)
# completed (at 500 ms)
