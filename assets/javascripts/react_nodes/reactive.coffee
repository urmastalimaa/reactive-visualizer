Observable = React.createClass

  handleAddOperator: (type) ->
    currentOperators = @props.observable.operators
    last = R.last(currentOperators)
    newOperators = currentOperators.concat([type: type, id: "#{last.id}o"])
    @props.onChange(root: @props.observable.root, operators: newOperators)

  render: ->
    {root, operators} = @props.observable

    rootNode = <ObservableRoot type={root.type} id={root.id} />

    operatorNodes = operators.map ({type, id}) ->
      <ObservableOperator type={type} id={id}/>

    <div className="observable">
     {rootNode}
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
  render: ->
    simulationArea = <SimulationArea />
    opEl = React.createElement(opClasses[@props.type], id: @props.id, simulationArea)

    <div className="observableOperator">
      {opEl}
    </div>

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
