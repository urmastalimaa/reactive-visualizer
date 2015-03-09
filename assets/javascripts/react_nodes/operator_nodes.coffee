V = Visualizer
N = Visualizer.ReactNodes

SimpleOperator = React.createClass
  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    if V.Operators[@props.operator.type].getDefaultArgs
      <N.Helpers.InputArea value={@props.operator.args} id={@props.operator.id} onChange={@onArgsChange} />
    else
      false

RecursiveOperator = React.createClass
  render: ->
    <span className="recursiveContainer" style={paddingLeft: '50px'} >
      <N.Observable id={@props.operator.id} observable={@props.operator.observable} recursionLevel={@props.recursionLevel + 1} onChange={@props.onChildOperatorChange} />
    </span>

RecursionFunctionOperator = React.createClass
  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    <span className="recusiveFunctionOperator">
      <span className="functionDeclaration" id={@props.operator.id}>
        <N.Helpers.InputArea value={@props.operator.args} onChange={@onArgsChange}/>
      </span>
      <RecursiveOperator operator={@props.operator} recursionLevel={@props.recursionLevel} onChildOperatorChange={@props.onChildOperatorChange} onChange={@props.onChange}/>
      {'}'}
    </span>

RecursiveOperatorWithTrailingArgs = React.createClass
  onArgsChange: (args) ->
    @props.onChange(R.assoc('args', args, @props.operator))

  render: ->
    <span>
      <RecursiveOperator operator={@props.operator} recursionLevel={@props.recursionLevel} onChildOperatorChange={@props.onChildOperatorChange} onChange={@props.onChange}/>
      ,
      <span className="recursiveOperatorTrailingArg" id={@props.operator.id}>
        <N.Helpers.InputArea value={@props.operator.args} onChange={@onArgsChange} />
      </span>
    </span>


getOperatorClass = ({recursionType}) ->
  switch recursionType
    when 'none' then SimpleOperator
    when 'function' then RecursionFunctionOperator
    when 'observable' then RecursiveOperator
    when 'observableWithSelector' then RecursiveOperatorWithTrailingArgs

N.ObservableOperator = React.createClass
  handleRemove: ->
    @props.onRemove(@props.operator)

  handleChildObservableChange: (observable) ->
    @props.onChildOperatorChange(@props.operator, observable)

  onChange: (operator) ->
    @props.onChange(operator)

  render: ->

    args = {
      operator: @props.operator
      onChildOperatorChange: @handleChildObservableChange
      recursionLevel: @props.recursionLevel
      onChange: @onChange
    }
    opEl = React.createElement(getOperatorClass(@props.operator), args)

    <div className={@props.operator.type} id={@props.operator.id} style={width: '100%'}>
      {".#{@props.operator.type}("} {opEl} {')'}
      {@props.children}
      <RemoveOperator onRemove={@handleRemove}/>
      <N.SimulationArea />
    </div>

RemoveOperator = React.createClass
  handleClick: ->
    @props.onRemove()
  render: ->
    <button className='remove' onClick={@handleClick}>-</button>

