R = require 'ramda'
React = require 'react'
Roots = require '../../descriptors/roots'
InputArea = require './input_area'
SimulationArea = require './simulation_nodes'
getDocLink = require('../../documentation_provider').getDocLink

SelectRoot = React.createClass
  handleChange: ->
    select = @refs.selectRoot.getDOMNode()
    val = select.options[select.selectedIndex].value
    @props.onChange(val)

  render: ->
    options = R.keys(Roots).map (root) ->
      <option value={root} key={root}>{root}</option>

    <span className="rootSelect">
      <select id={@props.id}{'selectRoot'} className='selectRoot' onChange={@handleChange} ref="selectRoot" value={@props.selected}>
        {options}
      </select>
    </span>

module.exports = React.createClass
  handleRootTypeChange: (type) ->
    @props.handleChange(type: type, args: Roots[type].getDefaultArgs?())

  onArgsChange: (args) ->
    @props.handleChange(type: @props.root.type, id: @props.root.id, args: args)

  handleArgChange: R.curryN 2, (position, value) ->
    args = @props.root.args
    args[position] = value
    @onArgsChange(args)


  render: ->
    {root} = @props
    nodes = R.mapIndexed( (arg, index) =>
      <InputArea value={arg} key={index} onChange={@handleArgChange(index).bind(@)} />
    )(root.args)

    <span className="simpleOperatorArgumentsContainer">
      {nodes}
    </span>
    <div className="root" data-type={root.type} id={root.id}>
      <div className="rootDescriptionContainer">
        <span className="immutableCode">{'Rx.Observable.'}</span>
        <SelectRoot id={root.id} selected={root.type} onChange={@handleRootTypeChange}/>
        <span className="immutableCode">{'('}</span>
        { nodes }
        <span className="immutableCode">{')'}</span>
      </div>
      {@props.children}
      <a href={getDocLink(root.type)} target="_blank">
        {"[doc]"}
      </a>
      <SimulationArea id={root.id} />
    </div>
