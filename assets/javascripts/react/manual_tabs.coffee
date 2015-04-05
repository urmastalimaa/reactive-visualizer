React = require 'react'
R = require 'ramda'
MarkdownIt = require 'markdown-it'

fs = require 'fs'
# the following cannot be refactored because of the way how `brfs` works

markdowns =
  General: fs.readFileSync('manual/general.md', 'utf8')
  ObservableEditor: fs.readFileSync('manual/observable_editor.md', 'utf8')
  Inspector: fs.readFileSync('manual/inspector.md', 'utf8')
  VirtualTimeController: fs.readFileSync('manual/virtual_time_controller.md', 'utf8')
  Persistence: fs.readFileSync('manual/persistence.md', 'utf8')

renderMarkdown = (markdown) ->
  MarkdownIt('default', html: true).render(markdown)

createManualClass = (html) ->
  React.createClass
    render: ->
      <div className="manualText" dangerouslySetInnerHTML={__html: html} />

classes = R.mapObj(R.compose(createManualClass, renderMarkdown))(markdowns)

module.exports = classes
