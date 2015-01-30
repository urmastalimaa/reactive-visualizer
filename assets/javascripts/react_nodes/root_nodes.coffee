V = Visualizer
N = Visualizer.ReactNodes
R = N.Roots = {}

R.of = React.createClass
  render: ->
    defArgs = "1, 2, 3, 4, 5, 6"
    <div className="of" id={@props.id}>
      {'Rx.Observable.of('} <N.Helpers.VarargsArea defaultValue={defArgs}/> {')'}
      {@props.children}
    </div>

R.fromTime = React.createClass
  render: ->
    defArgs = "{500: 1, 1000: 2, 1500: 3, 2000: 4, 2500: 5}"
    <div className="fromTime" id={@props.id}>
      {'Rx.Observable.fromTime('} <N.Helpers.VarargsArea defaultValue={defArgs}/> {')'}
      {@props.children}
    </div>
