V = Visualizer
N = V.ReactNodes

Observable = React.createClass
  handleAddOperator: (operator, type) ->
    return unless type

    operators = @props.observable.operators
    operatorIndex = R.indexOf(operator, operators)
    previous = R.slice(0, operatorIndex + 1, operators)
    after = R.slice(operatorIndex + 1, operators.length, operators)

    newList = R.concat(R.concat(previous, [{type}]), after)

    @props.onChange R.mixin @props.observable,
      operators: newList

  handleChildObservableChange: (operator, observable, recursionType) ->
    operator.observable = observable
    operator.recursionType = recursionType
    @props.onChange @props.observable

  removeOperator: (operator) ->
    @props.onChange R.mixin @props.observable,
      operators: R.reject(R.eq(operator), @props.observable.operators)

  handleRootChange: (root) ->
    @props.onChange R.mixin @props.observable,
      root: root

  render: ->
    handleAddOperatorTo = R.curryN 2, @handleAddOperator
    {root, operators} = @props.observable
    root.id = @props.id + 'r'

    newId = root.id + Array(operators.length + 2).join("o")

    operatorNodes = operators.map (operator, index) =>
      operator.id = root.id + Array(index + 2).join("o")
      <N.ObservableOperator operator={operator} onRemove={@removeOperator} onChildOperatorChange={@handleChildObservableChange} recursionLevel={@props.recursionLevel}>
        <AddOperator id={operator.id} onSelect={handleAddOperatorTo(operator)}/>
      </N.ObservableOperator>

    <div className="observable" style={paddingLeft: 'inherit'}>
     <V.ObservableRoot root={root} handleChange={@handleRootChange} >
      <AddOperator id={root.id} onSelect={handleAddOperatorTo(root)}/>
     </V.ObservableRoot>
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

    options = R.keys(N.OperatorClasses).map (op) ->
      <option value={op}>{op}</option>

    <span onMouseEnter={handleMouseEnter} onMouseLeave={handleMouseLeave} ref="addOperatorSpan">
      {'+'}
      <select id={@props.id}{'addOperator'} className='addOperators' onChange={@handleChange} ref="selectOperatorInput" hidden={@state.hidden}>
        <option value="">{'operator'}</option>
        {options}
      </select>
    </span>

window.Observable = Observable
