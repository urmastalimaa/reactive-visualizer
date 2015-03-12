R = require 'ramda'
React = require 'react'
Operators = require '../../descriptors/operators'
Observable = require './observable'
InputArea = require './input_area'
SimulationArea = require './simulation_nodes'

SimpleOperator = React.createClass
  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    if Operators[@props.operator.type].getDefaultArgs
      <InputArea value={@props.operator.args} id={@props.operator.id} onChange={@onArgsChange} />
    else
      false

RecursiveOperator = React.createClass
  render: ->
    <span className="recursiveContainer" style={paddingLeft: '50px'} >
      <Observable id={@props.operator.id} observable={@props.operator.observable} recursionLevel={@props.recursionLevel + 1} onChange={@props.onChildOperatorChange} />
    </span>

RecursionFunctionOperator = React.createClass
  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    <span className="recusiveFunctionOperator">
      <span className="functionDeclaration" id={@props.operator.id}>
        <InputArea value={@props.operator.args} onChange={@onArgsChange}/>
      </span>
      <RecursiveOperator operator={@props.operator} recursionLevel={@props.recursionLevel} onChildOperatorChange={@props.onChildOperatorChange} onChange={@props.onChange}/>
      {'}'}
    </span>

RecursiveOperatorWithTrailingArgs = React.createClass
  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    <span>
      <RecursiveOperator operator={@props.operator} recursionLevel={@props.recursionLevel} onChildOperatorChange={@props.onChildOperatorChange} onChange={@props.onChange}/>
      ,
      <span className="recursiveOperatorTrailingArg" id={@props.operator.id}>
        <InputArea value={@props.operator.args} onChange={@onArgsChange} />
      </span>
    </span>


getOperatorClass = ({recursionType}) ->
  switch recursionType
    when 'none' then SimpleOperator
    when 'function' then RecursionFunctionOperator
    when 'observable' then RecursiveOperator
    when 'observableWithSelector' then RecursiveOperatorWithTrailingArgs

module.exports = React.createClass
  handleRemove: ->
    @props.onRemove(@props.operator)

  handleChildObservableChange: (observable) ->
    @props.onChildOperatorChange(@props.operator, observable)

  onChange: (operator) ->
    @props.onChange(operator)

  render: ->
    args = {
      operator: @props.operator
      onChildOperatorChange: @handleChildObservableChange
      recursionLevel: @props.recursionLevel
      onChange: @onChange
    }
    opEl = React.createElement(getOperatorClass(@props.operator), args)

    <div className={@props.operator.type} id={@props.operator.id} style={width: '100%'}>
      {".#{@props.operator.type}("} {opEl} {')'}
      {@props.children}
      <RemoveOperator onRemove={@handleRemove}/>
      <SimulationArea id={@props.operator.id} />
    </div>

RemoveOperator = React.createClass
  handleClick: ->
    @props.onRemove()
  render: ->
    <button className='remove' onClick={@handleClick}>-</button>

