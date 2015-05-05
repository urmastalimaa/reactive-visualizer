R = require 'ramda'
React = require 'react'
Operators = require '../../descriptors/operators'
getDocLink = require('../../documentation_provider').getDocLink
argTypes = require '../../descriptors/argument_types'
exampleObservable = require('../../../../example_observables')[0].observable
classificator = require '../../classificator'

InputArea = require './input_area'
Inspector = require './inspector'

RecursiveOperator = React.createClass
  render: ->
    <span className="recursiveContainer">
      <@props.ObservableEditor id={@props.id} observable={@props.observable} recursionLevel={@props.recursionLevel + 1} onChange={@props.onChildOperatorChange} />
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

      onObservableChange = (observable) =>
        handleArgChange(R.merge(arg, observable: observable))

      switch argType
        when argTypes.OBSERVABLE_FUNCTION
          onDeclarationChange = (declaration) =>
            handleArgChange(R.merge(observable: arg.observable, functionDeclaration: declaration))

          <span key={index}>
            <span className="functionDeclaration" id={@props.operator.id}>
              <InputArea value={arg.functionDeclaration} onChange={onDeclarationChange}/>
            </span>
            <RecursiveOperator id={@props.operator.id} observable={arg.observable} recursionLevel={@props.recursionLevel} onChildOperatorChange={onObservableChange} ObservableEditor={@props.ObservableEditor}/>
            {'}'}
          </span>

        when argTypes.OBSERVABLE
          <RecursiveOperator key={index} id={@props.operator.id} observable={arg.observable} recursionLevel={@props.recursionLevel} onChildOperatorChange={onObservableChange} ObservableEditor={@props.ObservableEditor} />

        when argTypes.FUNCTION, argTypes.VALUE
          <InputArea key={index} value={arg} onChange={handleArgChange} className={"input#{argType}"} />

        else
          console.error "this shouldnt happen", definition[@props.operator.type].argTypes, index

    )(@props.operator.args)

  intersperseWithCommas: (elements) ->
    R.mapIndexed(( element, index) ->
      if index < elements.length - 1
        <span key={index}>{element}, </span>
      else
        element
    )(elements)

  render: ->
    isSimple = classificator.isSimple(Operators[@props.operator.type])
    className = "operator#{if isSimple then ' simpleBlock' else ' observableBlock'}"

    docOperator = Operators[@props.operator.type].docAlias || @props.operator.type
    <div data-type={@props.operator.type} className={className}>
      <span className="operatorContainer">
        <span className="immutableCode">{".#{@props.operator.type}("}</span>
        {@intersperseWithCommas(@getArgContainer(@props.operator.argTypes))}
        <span className="immutableCode">{')'}</span>
      </span>
      {@props.children}
      <RemoveOperator onRemove={@handleRemove}/>
      <a href={getDocLink(docOperator)} target="_blank">
        {"?"}
      </a>
      <Inspector id={@props.operator.id} />
    </div>

RemoveOperator = React.createClass
  handleClick: ->
    @props.onRemove()
  render: ->
    <button className='remove' onClick={@handleClick}>-</button>

module.exports = Operator
