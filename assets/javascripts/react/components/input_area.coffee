React = require 'react'
Textarea = require 'react-textarea-autosize'

module.exports = React.createClass

  getDefaultProps: ->
    value: ""
    onChange: ->

  getInitialState: ->
    value: @props.value

  componentWillReceiveProps: (nextProps) ->
    @setState value: nextProps.value

  onChange: (event) ->
    @setState value: event.target.value

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
