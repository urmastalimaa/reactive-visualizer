V = Visualizer
N = V.ReactNodes

SelectRoot = React.createClass
  handleChange: ->
    select = @refs.selectRoot.getDOMNode()
    val = select.options[select.selectedIndex].value
    @props.onChange(val)

  render: ->
    options = R.keys(V.Roots).map (root) ->
      <option value={root} >{root}</option>

    <span>
      <select id={@props.id}{'selectRoot'} className='selectRoot' onChange={@handleChange} ref="selectRoot" defaultValue={@props.selected}>
        {options}
      </select>
    </span>

N.ObservableRoot = React.createClass
  handleRootTypeChange: (type) ->
    @props.handleChange(type: type, args: V.Roots[type].getDefaultArgs?())

  onArgsChange: (args) ->
    @props.handleChange(type: @props.root.type, id: @props.root.id, args: args)

  render: ->
    {root} = @props
    <div className="observableRoot">
      <div className={root.type} id={root.id}>
        {'Rx.Observable.'}
        <SelectRoot id={root.id} selected={root.type} onChange={@handleRootTypeChange}/>
        {'('}
        { if root.args?
          <N.Helpers.InputArea value={root.args} onChange={@onArgsChange}/>
        }
        {')'}
        {@props.children}
        <N.SimulationArea id={root.id} />
      </div>
    </div>
