React = require 'react'
R = require 'ramda'
MarkdownIt = require 'markdown-it'

fs = require 'fs'
# the following cannot be refactored because of the way how `brfs` works

markdowns =
  General: fs.readFileSync('help/general.md', 'utf8')
  Builder: fs.readFileSync('help/builder.md', 'utf8')
  SimulationDisplayer: fs.readFileSync('help/simulation_displayer.md', 'utf8')
  SimulationController: fs.readFileSync('help/simulation_controller.md', 'utf8')
  Persister: fs.readFileSync('help/persister.md', 'utf8')

renderMarkdown = (markdown) ->
  MarkdownIt('default', html: true).render(markdown)

createHelpClass = (html) ->
  React.createClass
    render: ->
      <div className="helpArea" dangerouslySetInnerHTML={__html: html} />

classes = R.mapObj(R.compose(createHelpClass, renderMarkdown))(markdowns)

module.exports = classes
