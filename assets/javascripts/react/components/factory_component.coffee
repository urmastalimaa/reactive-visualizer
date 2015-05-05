R = require 'ramda'

React = require 'react'
Factories = require '../../descriptors/factories'
InputArea = require './input_area'
Inspector = require './inspector'
getDocLink = require('../../documentation_provider').getDocLink
exampleObservable = require('../../../../example_observables')[0].observable
classificator = require '../../classificator'
serializeFactory = require('../../serializer').serializeFactory

SelectFactory = React.createClass
  render: ->
    handleChange = (event) => @props.onChange(event.target.value)

    options = R.keys(Factories).map (factory) ->
      <option value={factory} key={factory}>{factory}</option>

    <select id={@props.id}{'selectFactory'} className='selectFactory' onChange={handleChange} ref="selectFactory" value={@props.selected}>
      {options}
    </select>

Factory = React.createClass
  getDefaultProps: ->
    handleChange: ->
    factory: exampleObservable.factory

  handleFactoryTypeChange: (type) ->
    @props.handleChange(serializeFactory(@props.recursionLevel)(type: type))

  onArgsChange: (args) ->
    @props.handleChange(R.assoc('args', args, @props.factory))

  handleArgChange: R.curry (position, newValue) ->
    newArgs = R.mapIndexed((argValue, argPosition) ->
      if argPosition == position
        newValue
      else
        argValue
    )(@props.factory.args)

    @onArgsChange(newArgs)

  render: ->
    {factory} = @props
    argInputs = R.mapIndexed( (arg, index) =>
      argType = Factories[factory.type].argTypes[index]
      inputArea = <InputArea className={"input#{argType}"} value={arg} key={"" + @props.factory.type + index} onChange={@handleArgChange(index).bind(@)} />
      if index < factory.args.length - 1
        <span key={index}>
          {inputArea},
        </span>
      else
        inputArea
    )(factory.args)

    isSimple = classificator.isSimple(Factories[factory.type])
    className = "factory#{if isSimple then ' simpleBlock' else ' observableBlock'}"

    <div className={className} id={factory.id}>
      <div className="factoryDescriptionContainer">
        <span className="immutableCode">{'Rx.Observable.'}</span>
        <SelectFactory id={factory.id} selected={factory.type} onChange={@handleFactoryTypeChange}/>
        <span className="immutableCode">{'('}</span>
        { argInputs }
        <span className="immutableCode">{')'}</span>
      </div>
      {@props.children}
      <a href={getDocLink(factory.type)} target="_blank"> {"?"} </a>
      <Inspector id={factory.id} />
    </div>

module.exports = Factory
