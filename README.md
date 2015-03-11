Considerations:

* an operator occurring later can have an effect on a previous operator e.g `take`

This means that the observable must be evaluated fully to have the correct values for all the operators. 
So to have values for each operator in the observable, `do` blocks must be used which save the results.

Another thing to take into account is the difficulty of evaluating nested functions.
All of them must have a properly initiated context and they must be able to close over all the outer functions.

These considerations persuaded me to build the observable as a string containing javascript and evaluate it once.

For simulating the observable there are two possibilities:

1. Use virtual time
  * the good: All the results are available immediately, can step trough, pause, rewind, change speed and so forth.
  * the bad: Cannot use any real asynchronous calls inside the javascript
2. Use real time
  * the good: Can use real asynchronous calls e.g query a server.
  * the bad: Can only display values as they arrive, no time travelling

To Do

1. Create examples which can be loaded
1. Modularize system
1. Allow setting end of time
1. Style the UI
1. Live simulation using a timeout scheduler, allowing real requests.
1. Capture live simulation, playback similar to virtual time 
1. Try and parse user provided javascript snippet to create the observable.
1. Allow operators with arbitrary parameters using structured view for observables.
1. Query and parse operator descriptions from TypeScript definitions during building.

