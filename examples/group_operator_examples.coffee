Rx = require 'rx'

createObserver = ->
  Rx.Observer.create(
    (item) -> console.log(item)
    (error) -> console.log("error:", error, "\n")
    -> console.log("completed\n")
  )

Rx.Observable.interval(500)
  .bufferWithCount(2)
  .take(3)
  .subscribe(createObserver())
# [ 0, 1 ] (at 1000 ms)
# [ 2, 3 ] (at 2000 ms)
# [ 4, 5 ] (at 3000 ms)
# completed (at 3000 ms)

Rx.Observable.interval(400)
  .bufferWithTime(1000)
  .take(3)
  .subscribe(createObserver())
# [ 0, 1 ] (at 1000 ms)
# [ 2, 3 ] (at 2000 ms)
# [ 4, 5, 6 ] (at 3000 ms)
# completed (at 3000 ms)

Rx.Observable.interval(500)
  .take(5)
  .groupBy((x) -> x % 3 ) # group by `mod` 3
  .flatMap((groupedObservable) ->
    # groupBy produces an Observable of each group.
    # Flatten the Observable, by getting all the values
    # out of it, including the group key with the value.
    groupedObservable.map((x) ->
      {value: x, key: groupedObservable.key}
    )
  ).subscribe(createObserver())
# { value: 0, key: 0 } (at 500 ms)
# { value: 1, key: 1 } (at 1000 ms)
# { value: 2, key: 2 } (at 1500 ms)
# { value: 3, key: 0 } (at 2000 ms)
# { value: 4, key: 1 } (at 2500 ms)
# completed (at 2500 ms)
