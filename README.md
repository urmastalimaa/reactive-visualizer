## rx-visualize

### A tool for building an RxJS observable and inspecting it's state 

### Running it

* Clone the repository: `git clone https://github.com/urmastalimaa/rx-visualize.git`
* Install dependencies: `npm install` (*package.json* lists dependencies) [(npmjs.com)](https://www.npmjs.com/)
* Build the source code and run a local web-server: `grunt` or `grunt default` (*Gruntfile.js* describes these targets)
* Navigate to the application in a web browser `localhost:3700`

####
  The project will be soon made available as a package on `npm`

### Developing
* `grunt dev_watch`
* make tests
* implement stuff
* enjoy live reload in browser


### How it works

The user interfaces requests an observable from the user.
The observable is created using a builder.
The observable cannot at this time contain any *real* asynchronous calls.
The observable will be evalued and run through virtual time scheduler and the 
values from each operator will be collected.
Overwriting any of the existing Rx functions is avoided.


### Future

#### Allowing real world data

The observable can be visualized in real time
and the time scrolling can be enabled only to past values.

#### Accepting an observable written in plain javascript.

This would require some crazy `eval` magic or proxying Rx functions.
Proxying is probably much easier.


#### Allow operators with arbitrary parameters in the builder

#### Create the builder based on the operators Typescript definitions
