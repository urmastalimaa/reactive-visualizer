require '../test_helper'

html = "<!doctype html><html><head><meta charset='utf-8'></head><body></body></html>"

process.env.NODE_ENV = 'development'

before (next) ->
  done = (errors, window) ->
    global.window = window
    global.document = window.document
    global.document.body = document.getElementsByTagName('body')[0]

    global.navigator = window.navigator = {}
    navigator.userAgent = 'NodeJs JsDom'
    navigator.appVersion = ''

    delete require.cache[id] for id, key of require.cache

    global.HTMLElement = window.HTMLElement
    global.React = require 'react/addons'
    global.TestUtils = React.addons.TestUtils
    global.Simulate = TestUtils.Simulate

    next()

  require('jsdom').env(
    html: html
    done: done
  )

after ->
  global.React.unmountComponentAtNode(global.document.body)
  delete global.window
  delete global.document
  delete global.HTMLElement
  delete global.React
  delete global.TestUtils
  delete global.Simulate

afterEach ->
  # clean the DOM
  global.React.unmountComponentAtNode(global.document.body)

global.render = (component) ->
  global.React.render(component, global.document.body)

global.findByTag = (component, tag) ->
  global.TestUtils.findRenderedDOMComponentWithTag(component, tag)

global.findByClass = (component, className) ->
  global.TestUtils.findRenderedDOMComponentWithClass(component, className)

global.scryByClass = (component, className) ->
  global.TestUtils.scryRenderedDOMComponentsWithClass(component, className)

global.scryByTag = (component, className) ->
  global.TestUtils.scryRenderedDOMComponentsWithTag(component, className)
