Rx = require 'rx'

createObserver = ->
  Rx.Observer.create(
    (item) -> console.log(item)
    (error) -> console.log("error:", error, "\n")
    -> console.log("completed\n")
  )

oneToThree = Rx.Observable.range(1,3)

oneToThree
  .map (x) -> x * x
  .subscribe(createObserver())
# 1
# 4
# 9
# completed

oneToThree
  .filter (x) -> x > 2
  .subscribe(createObserver())
# 3
# completed

oneToThree
  .find (x) -> (x % 2) == 0
  .subscribe(createObserver())
# 2
# completed

oneToThree
  .take(1)
  .subscribe(createObserver())
# 1
# completed

oneToThree
  .skip(1)
  .subscribe(createObserver())
# 2
# 3
# completed
