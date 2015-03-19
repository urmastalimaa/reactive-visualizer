React = require 'react'
Textarea = require 'react-textarea-autosize'

module.exports = React.createClass

  getInitialState: ->
    value: @props.value

  onChange: ->
    @setState value: @refs.textarea.getDOMNode().value

  onBlur: ->
    @props.onChange(@state.value)

  render: ->
    className = "#{@props.className || ''} codeTextarea"
    <Textarea
      value={@state.value}
      ref="textarea"
      onChange={@onChange}
      onBlur={@onBlur}
      className={className}
      rows="1" />
