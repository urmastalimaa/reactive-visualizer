require '../react_test_helper'
sinon = require 'sinon'
R = require 'ramda'

describe 'OperatorComponent', ->
  props = memo().is -> {}

  beforeEach ->
    Operator = require assetPath + 'react/components/operator_component'
    @operator = operator = render(React.createElement(Operator, props()))

  it 'can be rendered', ->

