## Purpose
The *simulation displayer* shows values at a specific time for every *factory* and *operator* in the `Observable` builder.

## Time
Above the `Observable` description an integer is displayed which represents the relative time.  
Sometimes the integer might seem to be off by one, this is due to the asynchronous nature of the `Observable`.  

## Values
The values moving through the *operators* and *factories* appear next to them.  
Only values **leaving** the transformation are displayed.  

### Completion
When a part of the `Observable` *completes* a green `C` is displayed as a value.

### Error
When an error occurs in a *factory* or an *operator* the error message text in red is displayed as a value.

### Multiple values
When multiple values appear at the exact same time, then they are displayed next to each other.  
One unit of time is surrounded by a little border.  

### Previous values
As new values appear, older ones are shifted to the left.  
The most recent value is always the rightmost.  

## Changes to the `Observable`
Whenever the `Observable` is changed, it is analyzed and the values are updated in real-time.
