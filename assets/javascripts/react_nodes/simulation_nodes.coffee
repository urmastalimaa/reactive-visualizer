V = Visualizer
N = V.ReactNodes

N.SimulationArea = React.createClass
  render: ->
    <span className="simulationArea" style={float: 'right'} >
      <SimulationValueArea />
      <SimulationErrorArea />
      <SimulationCompleteArea />
    </span>

SimulationValueArea = React.createClass
  render: ->
    <span>
      {'Value:'}<span className="value" />
    </span>

SimulationErrorArea = React.createClass
  render: ->
    <span>
      {'Error:'}<span className="error" />
    </span>

SimulationCompleteArea = React.createClass
  render: ->
    <span>
      {'Complete:'}<span className="complete" />
    </span>
