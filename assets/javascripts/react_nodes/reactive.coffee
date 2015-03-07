V = Visualizer
N = V.ReactNodes

N.Roots =
  of:
    defaultArgs: "1,2,3"
  fromTime:
    defaultArgs: "{500: 1, 1000: 2, 3000: 3}"

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

    newId = @props.id + Array(operators.length + 2).join("o")

    operatorNodes = operators.map (operator, index) =>
      id = @props.id + Array(index + 2).join("o")
      operator.id = id
      <ObservableOperator id={id} operator={operator} onRemove={@removeOperator} onChildOperatorChange={@handleChildObservableChange} recursionLevel={@props.recursionLevel}>
        <AddOperator id={id} onSelect={handleAddOperatorTo(operator)}/>
      </ObservableOperator>

    <div className="observable" style={paddingLeft: 'inherit'}>
     <ObservableRoot type={root.type} id={@props.id} args={root.args} handleChange={@handleRootChange} >
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

    options = R.keys(N.Operators).map (op) ->
      <option value={op}>{op}</option>

    <span onMouseEnter={handleMouseEnter} onMouseLeave={handleMouseLeave} ref="addOperatorSpan">
      {'+'}
      <select id={@props.id}{'addOperator'} className='addOperators' onChange={@handleChange} ref="selectOperatorInput" hidden={@state.hidden}>
        <option value="">{'operator'}</option>
        {options}
      </select>
    </span>

SelectRoot = React.createClass
  handleChange: ->
    select = @refs.selectRoot.getDOMNode()
    val = select.options[select.selectedIndex].value
    @props.onChange(val)

  render: ->
    options = R.keys(N.Roots).map (root) ->
      <option value={root} >{root}</option>

    <span>
      <select id={@props.id}{'selectRoot'} classnName='selectRoot' onChange={@handleChange} ref="selectRoot" defaultValue={@props.selected}>
        {options}
      </select>
    </span>

ObservableRoot = React.createClass
  handleRootTypeChange: (type) ->
    @props.handleChange(type: type, id: @props.id)

  render: ->
    <div className="observableRoot">
      <div className={@props.type} id={@props.id}>
        {'Rx.Observable.'}
        <SelectRoot id={@props.id} selected={@props.type} onChange={@handleRootTypeChange}/>
        {'('}
        <N.Helpers.InputArea defaultValue={@props.args || N.Roots[@props.type].defaultArgs} />
        {')'}
        {@props.children}
        <N.SimulationArea />
      </div>
    </div>

ObservableOperator = React.createClass
  handleRemove: ->
    @props.onRemove(@props.operator)

  handleChildObservableChange: (observable, recursionType) ->
    @props.onChildOperatorChange(@props.operator, observable, recursionType)

  render: ->
    {type, observable, args} = @props.operator
    opEl = React.createElement(N.Operators[type], args: args, id: @props.id, observable: observable, onChildOperatorChange: @handleChildObservableChange, recursionLevel: @props.recursionLevel)

    <div className={type} id={@props.id} style={width: '100%'}>
      {".#{type}("} {opEl} {')'}
      {@props.children}
      <RemoveOperator onRemove={@handleRemove}/>
      <N.SimulationArea />
    </div>

RemoveOperator = React.createClass
  handleClick: ->
    @props.onRemove()
  render: ->
    <button className='remove' onClick={@handleClick}>-</button>

window.Observable = Observable
