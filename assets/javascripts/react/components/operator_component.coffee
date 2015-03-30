R = require 'ramda'
React = require 'react'
Operators = require '../../descriptors/operators'
getDocLink = require('../../documentation_provider').getDocLink
argTypes = require '../../descriptors/argument_types'
exampleObservable = require('../../../../example_observables')[0].observable

InputArea = require './input_area'
SimulationArea = require './simulation_nodes'

RecursiveOperator = React.createClass
  render: ->
    <span className="recursiveContainer">
      <@props.ObservableComponent id={@props.id} observable={@props.observable} recursionLevel={@props.recursionLevel + 1} onChange={@props.onChildOperatorChange} />
    </span>

Operator = React.createClass
  getDefaultProps: ->
    onChange: ->
    onRemove: ->
    operator: exampleObservable.operators[0]

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
      argType = definition.argTypes[index]
      switch argType
        when argTypes.OBSERVABLE_FUNCTION
          onDeclarationChange = (declaration) =>
            handleArgChange(R.merge(observable: arg.observable, functionDeclaration: declaration))
          onObservableChange = (observable) =>
            handleArgChange(R.merge(arg, observable: observable))

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
          <InputArea key={index} value={arg} onChange={handleArgChange} className={"input#{argType}"} />

        else
          console.error "this shouldnt happen", definition[@props.operator.type].argTypes, index

    )(@props.operator.args)

  render: ->
    docOperator = Operators[@props.operator.type].docAlias || @props.operator.type
    <div data-type={@props.operator.type} className='operator'>
      <span className="operatorContainer">
        <span className="immutableCode">{".#{@props.operator.type}("}</span>
        {@getArgContainer(@props.operator.argTypes)}
        <span className="immutableCode">{')'}</span>
      </span>
      {@props.children}
      <RemoveOperator onRemove={@handleRemove}/>
      <a href={getDocLink(docOperator)} target="_blank">
        {"?"}
      </a>
      <SimulationArea id={@props.operator.id} />
    </div>

RemoveOperator = React.createClass
  handleClick: ->
    @props.onRemove()
  render: ->
    <button className='remove' onClick={@handleClick}>-</button>

module.exports = Operator
