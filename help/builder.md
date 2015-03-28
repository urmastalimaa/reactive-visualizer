## Purpose
The *builder* provides a structured *JavaScript* writing environment for creating an `Observable`.

## *Factory*
The creation of an `Observable` is started by providing a `factory` method, which produces the initial values.  
A list of `factory` methods is provided in the dropdown that appears next to `Rx.Observable.`.

The simplest `Observable` consists of a single `factory` method.
e.g
```js
  Rx.Observable.just(5)
```

## *Operators*
A new `Observable` can be created by applying a transformation `operator` to it.
An interval of 5 values every 500ms is created by:
```js
  Rx.Observable.interval(500)
    .take(5)
```

A list of `operators` is provided in the dropdown which opens when hovering over the `+` icon.  
An `operator` can be removed by clicking the `-` icon.

## Arguments

The arguments for any `operator` or `factory` can be provided by writing a *JavaScript* expression.  
There is always a default expression provided.  
When making changes, the return type of the expression must remain same.

### Nested `Observables`

Some `operators` can have arguments which themselves are an `Observable`.  
In that case a nested `Observable` builder is created.  

The builder produces an `Observable` which corresponds to the last specified outmost transformation.
