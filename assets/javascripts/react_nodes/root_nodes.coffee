V = Visualizer
N = V.ReactNodes

N.Roots =
  of:
    defaultArgs: "1,2,3"
    hasInput: true
    useScheduler: false
  fromTime:
    defaultArgs: "{500: 1, 1000: 2, 3000: 3}"
    hasInput: true
    useScheduler: true

SelectRoot = React.createClass
  handleChange: ->
    select = @refs.selectRoot.getDOMNode()
    val = select.options[select.selectedIndex].value
    @props.onChange(val)

  render: ->
    options = R.keys(N.Roots).map (root) ->
      <option value={root} >{root}</option>

    <span>
      <select id={@props.id}{'selectRoot'} className='selectRoot' onChange={@handleChange} ref="selectRoot" defaultValue={@props.selected}>
        {options}
      </select>
    </span>


V.ObservableRoot = React.createClass
  handleRootTypeChange: (type) ->
    @refs.argsInput.getDOMNode().value = @getDefaultArgs(type)
    @props.handleChange(type: type, id: @props.id)

  getDefaultArgs: (type) ->
    N.Roots[type].defaultArgs

  render: ->
    <div className="observableRoot">
      <div className={@props.type} id={@props.id}>
        {'Rx.Observable.'}
        <SelectRoot id={@props.id} selected={@props.type} onChange={@handleRootTypeChange}/>
        {'('}
        <N.Helpers.InputArea defaultValue={@props.args || @getDefaultArgs(@props.type)} ref="argsInput"/>
        {')'}
        {@props.children}
        <N.SimulationArea />
      </div>
    </div>
