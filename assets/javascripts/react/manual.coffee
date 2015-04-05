React = require 'react'
R = require 'ramda'
S = require 'string'

{Accordion, Panel} = require 'react-bootstrap'
{TabbedArea, TabPane} = require 'react-bootstrap'

ManualTabs = require './manual_tabs'

DescriptionContainer = React.createClass
  render: ->
    manualTabs = R.mapIndexed((panelKey, index) ->
      <TabPane key={index} eventKey={index} tab={S(panelKey).humanize().s}>
        {React.createElement(ManualTabs[panelKey])}
      </TabPane>
    )(R.keys(ManualTabs))

    <Accordion id='manual'>
      <Panel ref='pane' id="manualPanel" header='Manual' eventKey='1'>
        <TabbedArea defaultActiveKey={0}>
          {manualTabs}
        </TabbedArea>
      </Panel>
    </Accordion>

module.exports = DescriptionContainer
