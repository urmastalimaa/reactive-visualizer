React = require 'react'

module.exports = React.createClass
  onChange: ->
    @props.onChange(@refs.textarea.getDOMNode().value)
  render: ->
    <textarea type="text" style={height: 30, width: 400} value={@props.value} onChange={@onChange} ref="textarea"/>
