V = Visualizer
N = Visualizer.ReactNodes
R = N.Roots = {}

R.of = React.createClass
  render: ->
    defArgs = @props.args || "1,2,3"
    <div className="of" id={@props.id}>
      {'Rx.Observable.of('} <N.Helpers.VarargsArea defaultValue={defArgs}/> {')'}
      {@props.children}
    </div>

R.fromTime = React.createClass
  render: ->
    defArgs = @props.args || "{500: 1, 1000: 2, 3000: 3}"
    <div className="fromTime" id={@props.id}>
      {'Rx.Observable.fromTime('} <N.Helpers.VarargsArea defaultValue={defArgs}/> {')'}
      {@props.children}
    </div>
