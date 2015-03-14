React = require 'react'
R = require 'ramda'
Persister = require '../../persistency/persister'
examples = require '../../../../example_observables'
Loader = require './load_selector'
ReactBootstrap = require 'react-bootstrap'
{Button, ButtonToolbar, ButtonGroup} = ReactBootstrap

module.exports = React.createClass
  save: ->
    Persister.save(@props.observable)

  load: ->
    loaded = Persister.load()
    if loaded
      @props.onChange(loaded)

  onLoad: (exampleKey) ->
    @props.onChange examples[exampleKey]

  clear: ->
    Persister.clear()
    @props.onChange(@props.defaultObservable)

  render: ->
    exampleDescriptions = R.mapObj(R.get('description'))(examples)
    <ButtonToolbar id="persistency">
      <ButtonGroup>
        <Button id="save" tooltip="funky" bsStyle="primary" onClick={@save}  >Save </Button>
        <Button id="load"  bsStyle="primary" onClick={@load}  >Reset</Button>
        <Button id="clear" bsStyle="primary" onClick={@clear} >Clear</Button>
      </ButtonGroup>
      <ButtonGroup>
        <Loader onChange={@onLoad} options={exampleDescriptions}/>
      </ButtonGroup>
    </ButtonToolbar>

