### Purpose
The inspector shows values at a specified time for every Observable building block in the Observable editor.

### Time
Above the Observable editor is row containing integers which denote the virtual time in milliseconds.  
Sometimes the integers might seem to be off by one, this is due to the asynchronous nature of the Observable.  

### Values
The values leaving the Observable building blocks appear next to them.  
Faintly colored visual clues help to identify which building block the values come from.  
Note that only values **leaving** a building block are displayed.  

#### Completion
When some part of the Observable *completes* a green `C` is displayed in the inspector.

#### Error
When an error occurs in a part of the Observable the error message text is displayed in the inspector in red.

#### Multiple values
When multiple values come from a building block at the exact same time, then they are displayed next to each other.  
One unit of time is surrounded by a little border.  

#### Previous values
As new values appear, older ones are shifted to the left.  
The most recent value is always the rightmost.  

### Changes to the Observable
Whenever the Observable is changed in the editor, it is analyzed and the values are updated in the inspector immediately.
