V = Visualizer
N = V.ReactNodes

N.Roots =
  of:
    defaultArgs: "1,2,3"
    useScheduler: false
  just:
    defaultArgs: "5"
    useScheduler: true
  fromTime:
    defaultArgs: "{500: 1, 1000: 2, 3000: 3}"
    useScheduler: true
  interval:
    defaultArgs: "1000"
    useScheduler: true
  timer:
    defaultArgs: "500, 2000"
    useScheduler: true
  repeat:
    defaultArgs: "42, 3"
    useScheduler: true
  generate:
    defaultArgs: "0, function(x){ return x < 3;}, function(x) { return x + 1;}, function(x) { return x; }"
    useScheduler: true
  generateWithRelativeTime:
    defaultArgs: "1, function(x) { return x < 4;}, function(x) { return x + 1;}, function(x) { return x; }, function(x) { return 500 * x; }"
    useScheduler: true
  never:
    useScheduler: false
  empty:
    useScheduler: true
  range:
    defaultArgs: "1, 5"
    useScheduler: true
  pairs:
    defaultArgs: "{foo: 42, bar: 56, baz: 78}"
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
    if argsInput = @refs.argsInput
      argsInput.getDOMNode().value = @getDefaultArgs(type)
    @props.handleChange(type: type, id: @props.id)

  getDefaultArgs: (type) ->
    N.Roots[type].defaultArgs

  render: ->
    {root} = @props
    <div className="observableRoot">
      <div className={root.type} id={root.id}>
        {'Rx.Observable.'}
        <SelectRoot id={root.id} selected={root.type} onChange={@handleRootTypeChange}/>
        {'('}
        { if defaultArgs = @getDefaultArgs(root.type)
          <N.Helpers.InputArea defaultValue={root.args || defaultArgs} ref="argsInput"/>
        }
        {')'}
        {@props.children}
        <N.SimulationArea />
      </div>
    </div>
