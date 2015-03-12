React = require 'react'
R = require 'ramda'
Operators = require '../../descriptors/operators'

ObservableOperator = require './operator_nodes'
ObservableRoot = require './root_nodes'

Observable = React.createClass
  handleAddOperator: (operator, type) ->
    return unless type

    operators = @props.observable.operators
    operatorIndex = R.indexOf(operator, operators)
    previous = R.slice(0, operatorIndex + 1, operators)
    after = R.slice(operatorIndex + 1, operators.length, operators)

    newList = R.concat(R.concat(previous, [{type}]), after)

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

  handleRootChange: (root) ->
    @props.onChange R.merge @props.observable,
      root: root

  render: ->
    handleAddOperatorTo = R.curryN 2, @handleAddOperator
    {root} = @props.observable

    operatorNodes = @props.observable.operators.map (operator, index) =>
      <ObservableOperator operator={operator} onRemove={@removeOperator} onChildOperatorChange={@handleChildObservableChange} recursionLevel={@props.recursionLevel} onChange={@handleOperatorChange} key={operator.id}>
        <AddOperator id={operator.id} onSelect={handleAddOperatorTo(operator)}/>
      </ObservableOperator>

    <div className="observable" style={paddingLeft: 'inherit'}>
     <ObservableRoot root={root} handleChange={@handleRootChange} >
      <AddOperator id={root.id} onSelect={handleAddOperatorTo(root)}/>
     </ObservableRoot>
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

module.exports = Observable
