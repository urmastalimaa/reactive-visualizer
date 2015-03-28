React = require 'react'
Page = require './react/page'

document.addEventListener "DOMContentLoaded", ->
  React.render(<Page />, document.getElementById('content'))

