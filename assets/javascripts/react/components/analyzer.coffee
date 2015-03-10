V = Visualizer
N = V.ReactNodes

Rs = ReactBootstrap

Analyzer = React.createClass
  render: ->
    grid =
      <Rs.Grid>
        <Rs.Row>
          <Rs.Col sm={8}> See on tõesti väga, see on juba väga hea, see on tõesti väga hea </Rs.Col>
          <Rs.Col sm={4}> väga hea </Rs.Col>
        </Rs.Row>
        <Rs.Row>
          <Rs.Col sm={8}> Ja nüüd veel üks kord! See on tõesti väga, see on juba väga hea, see on tõesti väga hea </Rs.Col>
          <Rs.Col sm={4}> väga hea </Rs.Col>
        </Rs.Row>
      </Rs.Grid>

    <span>
      <div style={ float: 'left' }>
        <N.BuildArea defaultObservable={@props.defaultObservable} onChange={@props.onChange} style={width: '60%', float: 'left'} rowLength=8 />
        <div className="wut" style={paddingLeft: '10%', width: '30%', float: 'left'}>
          "This is good"
        </div>
      </div>
      <div>
        {grid}
      </div>
    </span>

N.Analyzer = Analyzer
