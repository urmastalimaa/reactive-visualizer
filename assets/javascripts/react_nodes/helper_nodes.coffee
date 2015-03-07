V = Visualizer
N = V.ReactNodes
H = N.Helpers = {}

H.InputArea = React.createClass
 render: ->
    <textarea type="text" style={height: 30, width: 300} defaultValue={@props.defaultValue}/>
