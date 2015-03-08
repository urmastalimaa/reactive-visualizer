V = Visualizer
N = V.ReactNodes

N.Roots =
  of:
    getDefaultArgs: R.always("1,2,3")
    useScheduler: false
  just:
    getDefaultArgs: R.always("5")
    useScheduler: true
  fromTime:
    getDefaultArgs: R.always("{500: 1, 1000: 2, 3000: 3}")
    useScheduler: true
  interval:
    getDefaultArgs: R.always("1000")
    useScheduler: true
  timer:
    getDefaultArgs: R.always("500, 2000")
    useScheduler: true
  repeat:
    getDefaultArgs: R.always("42, 3")
    useScheduler: true
  generate:
    getDefaultArgs: R.always("0, function(x){ return x < 3;}, function(x) { return x + 1;}, function(x) { return x; }")
    useScheduler: true
  generateWithRelativeTime:
    getDefaultArgs: R.always("1, function(x) { return x < 4;}, function(x) { return x + 1;}, function(x) { return x; }, function(x) { return 500 * x; }")
    useScheduler: true
  never:
    useScheduler: false
  empty:
    useScheduler: true
  range:
    getDefaultArgs: R.always("1, 5")
    useScheduler: true
  pairs:
    getDefaultArgs: R.always("{foo: 42, bar: 56, baz: 78}")
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
    @props.handleChange(type: type, args: N.Roots[type].getDefaultArgs?())

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
          <N.Helpers.InputArea value={root.args} ref="argsInput" onChange={@onArgsChange}/>
        }
        {')'}
        {@props.children}
        <N.SimulationArea />
      </div>
    </div>
