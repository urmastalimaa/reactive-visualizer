var fs = require('fs')
    coffeeReact = require('coffee-react');

// Install the compiler.
require.extensions['.coffee'] = function(module, filename) {
  var coffeeContents = fs.readFileSync(filename, 'utf-8');
  var compiled = coffeeReact.compile(coffeeContents);
  return module._compile(compiled, filename);
};
