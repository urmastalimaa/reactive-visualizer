V = Visualizer
N = Visualizer.ReactNodes
O = N.Operators = {}

O.map = React.createClass
  render: ->
    <N.Helpers.FunctionArea defaultValue="return value * value;"/>

O.filter = React.createClass
  render: ->
    <N.Helpers.FunctionArea defaultValue="return value < 20;"/>

O.delay = React.createClass
  render: ->
    <N.Helpers.VarargsArea defaultValue="100" />

O.bufferWithTime = React.createClass
  render: ->
    <N.Helpers.VarargsArea defaultValue="1000" />

