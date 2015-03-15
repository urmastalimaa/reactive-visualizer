R = require 'ramda'
React = require 'react'
Operators = require '../../descriptors/operators'
getDocLink = require('../../documentation_provider').getDocLink
argTypes = require '../../descriptors/argument_types'

InputArea = require './input_area'
SimulationArea = require './simulation_nodes'

RecursiveOperator = React.createClass
  render: ->
    <span className="recursiveContainer" style={paddingLeft: '50px'} >
      <@props.ObservableComponent id={@props.operator.id} observable={@props.operator.observable} recursionLevel={@props.recursionLevel + 1} onChange={@props.onChildOperatorChange} />
    </span>

module.exports = React.createClass
  handleRemove: ->
    @props.onRemove(@props.operator)

  handleChildObservableChange: (observable) ->
    @props.onChildOperatorChange(@props.operator, observable)

  onChange: (operator) ->
    @props.onChange(operator)

  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  handleArgChange: R.curryN 2, (position, value) ->
    args = @props.operator.args
    args[position] = value
    @onArgsChange(args)

  getArgContainer: (operatorArgTypes) ->
    realIndex = 0
    R.mapIndexed((type, index) =>
      res = if R.eq(type, argTypes.RECURSIVE_FUNCTION)
        <span key={index}>
          <span className="functionDeclaration" id={@props.operator.id}>
            <InputArea value={@props.operator.args} onChange={@onArgsChange}/>
          </span>
          {React.createElement(RecursiveOperator, @props)}
          {'}'}
        </span>
      else if R.eq(type, argTypes.OBSERVABLE)
        React.createElement(RecursiveOperator, R.merge(key: index, @props))
      else if R.eq(type, argTypes.FUNCTION) || R.eq(type, argTypes.VALUE)
        res = <InputArea value={@props.operator.args[realIndex]} key={index} onChange={@handleArgChange(realIndex).bind(@)} />
        realIndex += 1
        res
    )(operatorArgTypes)

  render: ->
    <div data-type={@props.operator.type} className='operator'>
      <span>
        <span className="immutableCode">{".#{@props.operator.type}("}</span>
        {@getArgContainer(@props.operator.argTypes)}
        <span className="immutableCode">{')'}</span>
      </span>
      {@props.children}
      <RemoveOperator onRemove={@handleRemove}/>
      <a href={getDocLink(@props.operator.type)} target="_blank">
        {"[doc]"}
      </a>
      <SimulationArea id={@props.operator.id} />
    </div>

RemoveOperator = React.createClass
  handleClick: ->
    @props.onRemove()
  render: ->
    <button className='remove' onClick={@handleClick}>-</button>

