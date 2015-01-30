V = Visualizer
N = V.ReactNodes
H = N.Helpers = {}

H.FunctionDeclaration = React.createClass
  render: ->
    <textarea type="text" style={height: 20, width: 200} defaultValue={@props.defaultValue}/>


H.TextArea = React.createClass
  render: ->
    <textarea type="text" style={height: 30, width: 300} defaultValue={@props.defaultValue}/>


H.FunctionArea = React.createClass
  render: ->
    <span className="functionArea">
      <textarea type="text" style={height: 30, width: 300} defaultValue={@props.defaultValue}/>
    </span>

H.VarargsArea = React.createClass
  render: ->
    <span className="varargsArea">
      <textarea type="text" style={height: 30, width: 300} defaultValue={@props.defaultValue}>
      </textarea>
    </span>
