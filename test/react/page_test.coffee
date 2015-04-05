require './react_test_helper'
sinon = require 'sinon'
R = require 'ramda'

describe 'Page', ->
  props = memo().is -> {}

  beforeEach ->
    Page = require assetPath + 'react/page'
    @page = page = render(React.createElement(Page, props()))

  it 'renders all the parts of the app', ->
    expect(document.getElementById('page')).toExist()
    expect(document.getElementById('virtualTimeControl')).toExist()
    expect(document.getElementById('play')).toExist()
    expect(document.getElementById('load')).toExist()
    expect(document.getElementById('save')).toExist()
    expect(document.getElementById('interactionArea')).toExist()
    expect(document.getElementById('manual')).toExist()

