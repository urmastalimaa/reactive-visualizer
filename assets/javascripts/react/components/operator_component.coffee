R = require 'ramda'
React = require 'react'
Operators = require '../../descriptors/operators'
getDocLink = require('../../documentation_provider').getDocLink

InputArea = require './input_area'
SimulationArea = require './simulation_nodes'

SimpleOperator = React.createClass
  handleArgChange: R.curryN 2, (position, value) ->
    args = @props.operator.args
    args[position] = value
    @onArgsChange(args)

  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    nodes = R.mapIndexed( (arg, index) =>
      <InputArea value={arg} key={index} onChange={@handleArgChange(index).bind(@)} />
    )(@props.operator.args)

    <span className="simpleOperatorArgumentsContainer">
      {nodes}
    </span>

RecursiveOperator = React.createClass
  render: ->
    <span className="recursiveContainer" style={paddingLeft: '50px'} >
      <@props.ObservableComponent id={@props.operator.id} observable={@props.operator.observable} recursionLevel={@props.recursionLevel + 1} onChange={@props.onChildOperatorChange} />
    </span>

RecursionFunctionOperator = React.createClass
  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    <span className="recusiveFunctionOperator">
      <span className="functionDeclaration" id={@props.operator.id}>
        <InputArea value={@props.operator.args} onChange={@onArgsChange}/>
      </span>
      <RecursiveOperator operator={@props.operator} recursionLevel={@props.recursionLevel} onChildOperatorChange={@props.onChildOperatorChange} onChange={@props.onChange} ObservableComponent={@props.ObservableComponent}/>
      {'}'}
    </span>

RecursiveOperatorWithTrailingArgs = React.createClass
  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    <span>
      <RecursiveOperator operator={@props.operator} recursionLevel={@props.recursionLevel} onChildOperatorChange={@props.onChildOperatorChange} onChange={@props.onChange} ObservableComponent={@props.ObservableComponent}/>
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
      ObservableComponent: @props.ObservableComponent
    }
    opEl = React.createElement(getOperatorClass(@props.operator), args)

    <div data-type={@props.operator.type} className='operator'>
      <span className="immutableCode">{".#{@props.operator.type}("}</span>
      {opEl}
      <span className="immutableCode">{')'}</span>
      <a href={getDocLink(@props.operator.type)} target="_blank">
        {"[doc]"}
      </a>
      {@props.children}
      <RemoveOperator onRemove={@handleRemove}/>
      <SimulationArea id={@props.operator.id} />
    </div>

RemoveOperator = React.createClass
  handleClick: ->
    @props.onRemove()
  render: ->
    <button className='remove' onClick={@handleClick}>-</button>

