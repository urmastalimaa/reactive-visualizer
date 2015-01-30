V = Visualizer
N = V.ReactNodes
H = N.Helpers = {}

H.FunctionArea = React.createClass
  render: ->
    <span className="functionArea">
      {'function(value) {'}
      <textarea type="text" style={height: 30, width: 300} defaultValue={@props.defaultValue}/>
      {'}'}
    </span>

H.VarargsArea = React.createClass
  render: ->
    <span className="varargsArea">
      <textarea type="text" style={height: 30, width: 300} defaultValue={@props.defaultValue}>
      </textarea>
    </span>
