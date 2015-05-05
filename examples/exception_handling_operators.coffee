Rx = require 'rx'

createObserver = ->
  Rx.Observer.create(
    (item) -> console.log(item)
    (error) -> console.log("error:", error, "\n")
    -> console.log("completed\n")
  )

Rx.Observable.throw("An error")
  .catch(Rx.Observable.just(2))
  .subscribe(createObserver())
# 2
# completed

mockRequestWithError = (delay, error) ->
  Rx.Observable.create (observer) ->
    console.log "starting request"
    Rx.Observable.timer(delay)
      .flatMap ->
        Rx.Observable.throw(error)
      .subscribe(observer)

mockRequestWithError(1000, 'Request timeout')
  .retry(3)
  .subscribe(createObserver())
# starting request (at 0 ms)
# starting request (at 1000 ms)
# starting request (at 2000 ms)
# error: Request timeout (at 3000 ms)

Rx.Observable.of(1)
  .onErrorResumeNext(Rx.Observable.of(2))
  .subscribe(createObserver())
# 1
# 2
# completed

Rx.Observable.throw('An error')
  .onErrorResumeNext(Rx.Observable.of(2))
  .subscribe(createObserver())
# 2
# completed
