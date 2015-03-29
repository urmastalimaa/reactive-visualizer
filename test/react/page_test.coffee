require './react_test_helper'
sinon = require 'sinon'

describe 'Page', ->
  props = memo().is -> {}

  findModals = getOpenButton = getCloseButton = null

  beforeEach ->
    Page = require assetPath + 'react/page'
    @page = page = render(React.createElement(Page, props()))

  it 'renders the the play button', ->
    expect(document.getElementById('play')).toExist()

  it 'renders the load button', ->
    expect(document.getElementById('load')).toExist()

  it 'renders the save button', ->
    expect(document.getElementById('save')).toExist()

  it 'renders the build area', ->
    expect(document.getElementById('buildArea')).toExist()

  it 'renders the help panel', ->
    expect(document.getElementById('help')).toExist()

