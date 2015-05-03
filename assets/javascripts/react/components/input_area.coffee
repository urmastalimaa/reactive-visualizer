React = require 'react'
Textarea = require 'react-textarea-autosize'
Rx = require 'rx'

clickInBody = Rx.Observable.defer(->
  Rx.Observable.fromEvent(document.body, 'click')
).share()

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

  componentDidMount: ->
    clickAfterChange = clickInBody
      .filter => @props.value != @state.value
    @_clickDisposable = clickAfterChange.subscribe(@onClickAfterChange)

  componentWillUnmount: ->
    @_clickDisposable.dispose()

  onClickAfterChange: ->
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
