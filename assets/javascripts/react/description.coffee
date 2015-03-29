React = require 'react'
R = require 'ramda'

{Accordion, Panel} = require 'react-bootstrap'
{TabbedArea, TabPane} = require 'react-bootstrap'

HelpTexts = require './help_texts'

DescriptionContainer = React.createClass
  render: ->
    helpTabs = R.mapIndexed((panelKey, index) ->
      <TabPane key={index} eventKey={index} tab={panelKey}>
        {React.createElement(HelpTexts[panelKey])}
      </TabPane>
    )(R.keys(HelpTexts))

    <Accordion id='informationContainer'>
      <Panel ref='pane' id="help" header='Help' eventKey='1'>
        <TabbedArea defaultActiveKey={0}>
          {helpTabs}
        </TabbedArea>
      </Panel>
    </Accordion>

module.exports = DescriptionContainer
