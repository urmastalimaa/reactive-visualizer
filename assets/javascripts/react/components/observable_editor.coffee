React = require 'react'
R = require 'ramda'
Operators = require '../../descriptors/operators'

Operator = require './operator_component'
Factory = require './factory_component'

serializeOperator = require('../../serializer').serializeOperator

ObservableEditor = React.createClass
  handleAddOperator: (operator, type) ->
    return unless type

    operators = @props.observable.operators
    operatorIndex = R.indexOf(operator, operators)
    previous = R.slice(0, operatorIndex + 1, operators)
    after = R.slice(operatorIndex + 1, operators.length, operators)
    operator = serializeOperator(@props.recursionLevel, type: type)

    newList = R.concat(R.append(operator, previous), after)

    @props.onChange R.merge @props.observable,
      operators: newList

  handleChildObservableChange: (operator, observable) ->
    # would be nicer to do without mutating
    operator.observable = observable
    @props.onChange @props.observable

  handleOperatorChange: (operator) ->
    # would be nicer to do without mutating
    oldIndex = R.findIndex(R.propEq('id', operator.id), @props.observable.operators)
    @props.observable.operators[oldIndex] = operator
    @props.onChange @props.observable

  removeOperator: (operator) ->
    @props.onChange R.merge @props.observable,
      operators: R.reject(R.eq(operator), @props.observable.operators)

  handleFactoryChange: (factory) ->
    @props.onChange R.merge @props.observable,
      factory: factory

  render: ->
    handleAddOperatorTo = R.curryN 2, @handleAddOperator
    {factory} = @props.observable

    operatorNodes = @props.observable.operators.map (operator, index) =>
      <Operator key={operator.type + operator.id + index} operator={operator} onRemove={@removeOperator} onChildOperatorChange={@handleChildObservableChange} recursionLevel={@props.recursionLevel}
        onChange={@handleOperatorChange} ObservableEditor={ObservableEditor}>
        <AddOperator id={operator.id} onSelect={handleAddOperatorTo(operator)}/>
      </Operator>

    <div className="observableEditor">
     <Factory factory={factory} handleChange={@handleFactoryChange} recursionLevel={@props.recursionLevel} >
      <AddOperator id={factory.id} onSelect={handleAddOperatorTo(factory)}/>
     </Factory>
     {operatorNodes}
    </div>

AddOperator = React.createClass
  handleChange: ->
    select = @refs.selectOperatorInput.getDOMNode()
    val = select.options[select.selectedIndex].value
    select.value = ""
    @props.onSelect(val) if val?

  getInitialState: ->
    hidden: true

  render: ->
    handleMouseEnter = =>
      @setState hidden: false
    handleMouseLeave = =>
      @setState hidden: true

    options = R.keys(Operators).map (op) ->
      <option value={op} key={op}>{op}</option>

    <span onMouseEnter={handleMouseEnter} onMouseLeave={handleMouseLeave} ref="addOperatorSpan">
      {'+'}
      <select id={@props.id}{'addOperator'} className='addOperators' onChange={@handleChange} ref="selectOperatorInput" hidden={@state.hidden}>
        <option value="">{'operator'}</option>
        {options}
      </select>
    </span>

module.exports = ObservableEditor
