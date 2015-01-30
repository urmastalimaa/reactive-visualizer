V = Visualizer
N = V.ReactNodes

Observable = React.createClass
  handleAddOperator: (type) ->
    {root, operators} = @props.observable
    last = R.last(operators)
    newOperators = operators.concat([type: type, id: "#{last.id}o"])
    @props.onChange(root: root, operators: newOperators)

  removeOperator: (operator) ->
    {root, operators} = @props.observable
    newOperators = R.clone(operators)
    newOperators.splice(operators.indexOf(operator), 1)
    @props.onChange(root: root, operators: newOperators)

  render: ->
    {root, operators} = @props.observable

    operatorNodes = operators.map (operator) =>
      <ObservableOperator operator={operator} onRemove={@removeOperator} />

    <div className="observable">
     <ObservableRoot type={root.type} id={root.id} />
     {operatorNodes}
     <AddOperator rootId={root.id} onSelect={@handleAddOperator}/>
    </div>

AddOperator = React.createClass
  handleChange: ->
    select = @refs.selectOperatorInput.getDOMNode()
    val = select.options[select.selectedIndex].value
    @props.onSelect(val) if val?

  render: ->
    options = R.keys(N.Operators).map (op) ->
      <option value={op}>{op}</option>
    <span>
      {'Add Operator'}
      <select id={@props.rootId}{'addOperator'} className='addOperators' onChange={@handleChange} ref="selectOperatorInput">
        <option value="">{'Select'}</option>
        {options}
      </select>
    </span>

ObservableRoot = React.createClass
  render: ->
    simulationArea = <N.SimulationArea />
    rootEl = React.createElement(N.Roots[@props.type], id: @props.id, simulationArea)
    <div className="observableRoot">
      {rootEl}
    </div>

ObservableOperator = React.createClass
  handleRemove: ->
    @props.onRemove(@props.operator)

  render: ->
    {id, type} = @props.operator
    opEl = React.createElement(N.Operators[type], id: id)

    <div className={type} id={id} style={width: '100%'}>
      {".#{type}("} {opEl} {')'}
      <RemoveOperator onRemove={@handleRemove}/>
      <N.SimulationArea />
    </div>

RemoveOperator = React.createClass
  handleClick: ->
    @props.onRemove()
  render: ->
    <button className='remove' onClick={@handleClick}>-</button>

window.Observable = Observable
