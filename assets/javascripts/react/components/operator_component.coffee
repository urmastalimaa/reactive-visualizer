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
      <@props.ObservableComponent id={@props.id} observable={@props.observable} recursionLevel={@props.recursionLevel + 1} onChange={@props.onChildOperatorChange} />
    </span>

module.exports = React.createClass
  handleRemove: ->
    @props.onRemove(@props.operator)

  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  handleArgChange: R.curryN 2, (position, value) ->
    args = @props.operator.args
    args[position] = value
    @onArgsChange(args)

  getArgContainer: ->
    definition = Operators[@props.operator.type]

    R.mapIndexed( (arg, index) =>
      handleArgChange = @handleArgChange(index).bind(@)
      switch definition.argTypes[index]

        when argTypes.OBSERVABLE_FUNCTION
          onDeclarationChange = (declaration) =>
            handleArgChange(R.merge(arg.observable, functionDeclaration: declaration))
          onObservableChange = (observable) =>
            handleArgChange(R.merge(arg.observable, observable: observable))

          <span key={index}>
            <span className="functionDeclaration" id={@props.operator.id}>
              <InputArea value={arg.functionDeclaration} onChange={onDeclarationChange}/>
            </span>
            <RecursiveOperator id={@props.operator.id} observable={arg.observable} recursionLevel={@props.recursionLevel} onChildOperatorChange={onObservableChange} ObservableComponent={@props.ObservableComponent}/>
            {'}'}
          </span>

        when argTypes.OBSERVABLE
          <RecursiveOperator key={index} id={@props.operator.id} observable={arg} recursionLevel={@props.recursionLevel} onChildOperatorChange={handleArgChange} ObservableComponent={@props.ObservableComponent} />

        when argTypes.FUNCTION, argTypes.VALUE
          <InputArea key={index} value={arg} onChange={handleArgChange} />

        else
          console.error "this shouldnt happen", definition[@props.operator.type].argTypes, index

    )(@props.operator.args)

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

