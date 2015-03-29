React = require 'react'
Page = require './react/page'
Persister = require './persistency/persister'

tries = 0
renderPage = ->
  try
    tries += 1
    React.render(<Page />, document.getElementById('content'))
  catch e
    console.error "Couldn't render page, retrying", e
    Persister.save(null)
    if tries < 3
      renderPage()

document.addEventListener "DOMContentLoaded", renderPage
