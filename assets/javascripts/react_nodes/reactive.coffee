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
    options = R.keys(opClasses).map (op) ->
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
    simulationArea = <SimulationArea />
    rootEl = React.createElement(rootClasses[@props.type], id: @props.id, simulationArea)
    <div className="observableRoot">
      {rootEl}
    </div>

ObservableOperator = React.createClass
  handleRemove: ->
    @props.onRemove(@props.operator)

  render: ->
    {id, type} = @props.operator
    opEl = React.createElement(opClasses[type], id: id)

    <div className={type} id={id} style={width: '50%'}>
      {".#{type}("} {opEl} {')'}
      <RemoveOperator onRemove={@handleRemove}/>
      <SimulationArea />
    </div>

RemoveOperator = React.createClass
  handleClick: ->
    @props.onRemove()
  render: ->
    <button className='remove' onClick={@handleClick}>-</button>

FunctionArea = React.createClass
  render: ->
    <span className="functionArea">
      {'function(value) {'}
      <textarea type="text" style={height: 30, width: 300} defaultValue={@props.defaultValue}/>
      {'}'}
    </span>

VarargsArea = React.createClass
  render: ->
    <span className="varargsArea">
      <textarea type="text" style={height: 30, width: 300} defaultValue={@props.defaultValue}>
      </textarea>
    </span>

SimulationArea = React.createClass
  render: ->
    <span className="simulationArea" style={float: 'right'} >
      <SimulationValueArea />
      <SimulationErrorArea />
      <SimulationCompleteArea />
    </span>

SimulationValueArea = React.createClass
  render: ->
    <span>
      {'Value:'}<span className="value" />
    </span>

SimulationErrorArea = React.createClass
  render: ->
    <span>
      {'Error:'}<span className="error" />
    </span>

SimulationCompleteArea = React.createClass
  render: ->
    <span>
      {'Complete:'}<span className="complete" />
    </span>

Map = React.createClass
  render: ->
    <FunctionArea defaultValue="return value * value;"/>

Filter = React.createClass
  render: ->
    <FunctionArea defaultValue="return value < 20;"/>

Delay = React.createClass
  render: ->
    <VarargsArea defaultValue="100" />

BufferWithTime = React.createClass
  render: ->
    <VarargsArea defaultValue="1000" />

Of = React.createClass
  render: ->
    defArgs = "1, 2, 3, 4, 5, 6"
    <div className="of" id={@props.id}>
      {'Rx.Observable.of('} <VarargsArea defaultValue={defArgs}/> {')'}
      {@props.children}
    </div>

FromTime = React.createClass
  render: ->
    defArgs = "{500: 1, 1000: 2, 1500: 3, 2000: 4, 2500: 5}"
    <div className="fromTime" id={@props.id}>
      {'Rx.Observable.fromTime('} <VarargsArea defaultValue={defArgs}/> {')'}
      {@props.children}
    </div>

rootClasses =
  of: Of
  fromTime: FromTime

opClasses =
  map: Map
  filter: Filter
  delay: Delay
  bufferWithTime: BufferWithTime

window.Observable = Observable
