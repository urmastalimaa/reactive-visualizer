V = Visualizer
N = V.ReactNodes
H = N.Helpers = {}

H.InputArea = React.createClass
  onChange: ->
    @props.onChange(@refs.textarea.getDOMNode().value)
  render: ->
    <textarea type="text" style={height: 30, width: 300} value={@props.value} onChange={@onChange} ref="textarea"/>
