R = require 'ramda'

React = require 'react'
Roots = require '../../descriptors/roots'
InputArea = require './input_area'
Inspector = require './inspector'
getDocLink = require('../../documentation_provider').getDocLink
exampleObservable = require('../../../../example_observables')[0].observable
classificator = require '../../classificator'
serializeRoot = require('../../serializer').serializeRoot

SelectRoot = React.createClass
  render: ->
    handleChange = (event) => @props.onChange(event.target.value)

    options = R.keys(Roots).map (root) ->
      <option value={root} key={root}>{root}</option>

    <select id={@props.id}{'selectRoot'} className='selectRoot' onChange={handleChange} ref="selectRoot" value={@props.selected}>
      {options}
    </select>

Root = React.createClass
  getDefaultProps: ->
    handleChange: ->
    root: exampleObservable.root

  handleRootTypeChange: (type) ->
    @props.handleChange(serializeRoot(@props.recursionLevel)(type: type))

  onArgsChange: (args) ->
    @props.handleChange(R.assoc('args', args, @props.root))

  handleArgChange: R.curry (position, newValue) ->
    newArgs = R.mapIndexed((argValue, argPosition) ->
      if argPosition == position
        newValue
      else
        argValue
    )(@props.root.args)

    @onArgsChange(newArgs)

  render: ->
    {root} = @props
    argInputs = R.mapIndexed( (arg, index) =>
      argType = Roots[root.type].argTypes[index]
      <InputArea className={"input#{argType}"} value={arg} key={"" + @props.root.type + index} onChange={@handleArgChange(index).bind(@)} />
    )(root.args)

    isSimple = classificator.isSimple(Roots[root.type])
    className = "root#{if isSimple then ' simpleBlock' else ' observableBlock'}"

    <div className={className} id={root.id}>
      <div className="rootDescriptionContainer">
        <span className="immutableCode">{'Rx.Observable.'}</span>
        <SelectRoot id={root.id} selected={root.type} onChange={@handleRootTypeChange}/>
        <span className="immutableCode">{'('}</span>
        { argInputs }
        <span className="immutableCode">{')'}</span>
      </div>
      {@props.children}
      <a href={getDocLink(root.type)} target="_blank"> {"?"} </a>
      <Inspector id={root.id} />
    </div>

module.exports = Root
