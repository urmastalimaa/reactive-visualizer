## Purpose
The *Observable editor* provides a *JavaScript* editor for creating an *Observable*.
The building blocks for creating an *Observable* are *roots* and *operators*.

## *Root*
An *Observable* if created by specifying a *root*, which produces the initial values.  
A list of *roots* is provided in the drop-down next to `Rx.Observable.`.

The simplest *Observable* consists of a single *root*:
```js
  Rx.Observable.just(5)
```

## *Operators*
An *Observable* can be transformed by applying an *operator* to it.
An *Observable* of 5 values every 500ms is created with:
```js
  Rx.Observable.interval(500)
    .take(5)
```

A list of *operators* is provided in the drop-down which opens when hovering over the `+` symbol.  
The `+` symbol is located next to existing *roots* and *operators*.  

An *operator* can be removed by clicking on the `-` symbol.

## Arguments

The arguments for any building block can be provided by as a *JavaScript* expression.  
There is always a default expression provided.  
When making changes, the return type of the expression must remain same.

### Nested *Observables*

Some building blocks can have arguments which themselves are *Observables*.  
In that case a nested *Observable editor* is created.  
