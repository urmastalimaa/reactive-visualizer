Considerations:

* an operator occurring later can have an effect on a previous operator e.g `take`

This means that the observable must be evaluated fully to have the correct values for all the operators. 
So to have values for each operator in the observable, `do` blocks must be used which save the results.

Another thing to take into account is the difficulty of evaluating nested functions.
All of them must have a properly initiated context and they must be able to close over all the outer functions.
 
