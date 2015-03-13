R = require 'ramda'
React = require 'react'
Roots = require '../../descriptors/roots'
InputArea = require './input_area'
SimulationArea = require './simulation_nodes'

SelectRoot = React.createClass
  handleChange: ->
    select = @refs.selectRoot.getDOMNode()
    val = select.options[select.selectedIndex].value
    @props.onChange(val)

  render: ->
    options = R.keys(Roots).map (root) ->
      <option value={root} key={root}>{root}</option>

    <span>
      <select id={@props.id}{'selectRoot'} className='selectRoot' onChange={@handleChange} ref="selectRoot" defaultValue={@props.selected}>
        {options}
      </select>
    </span>

module.exports = React.createClass
  handleRootTypeChange: (type) ->
    @props.handleChange(type: type, args: Roots[type].getDefaultArgs?())

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
          <InputArea value={root.args} onChange={@onArgsChange}/>
        }
        {')'}
        {@props.children}
        <SimulationArea id={root.id} />
      </div>
    </div>
