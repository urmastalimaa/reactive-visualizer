React = require 'react'
Page = require './react/page'
Persister = require './persistency/persister'

renderPage = ->
  try
    React.render(<Page />, document.getElementById('content'))
  catch e
    console.error "Couldn't render page, retrying", e
    Persister.save(null)
    renderPage()

document.addEventListener "DOMContentLoaded", renderPage
