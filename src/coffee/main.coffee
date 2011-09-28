nodes = {}
nodes.list = []
nodes.types = {}
nodes.types.Base = {}
nodes.types.Math = {}
nodes.types.Utils = {}
nodes.types.Geometry = {}
nodes.types.Three = {}
nodes.types.Materials = {}

fields = {}
fields.types = {}

#http://www.w3.org/TR/file-writer-api/
#http://www.html5rocks.com/en/tutorials/file/dndfiles/

svg = false

animate = () ->
  render()
  requestAnimationFrame( animate )

render = () ->
  nodegraph.render()


on_ui_window_resize = () ->
  w = $(window).width() - 4
  h = $(window).height() - 4
  $("#container-wrapper").css
    width: w
    height: h
  $("#sidebar").css("height", h)

  
$(document).ready ->
  $("#graph").svg
    onLoad: (s) ->
      svg = s
  make_sidebar_toggle()
  
  f1 = new fields.types.Float("test", 0.4)
  f1.signal.dispatch 42.0
  
  $("#sidebar").tabs
    fx:
      opacity: 'toggle'
      duration: 100
  console.log("starting...")
  init_tab_new_node()
  animate()
  
  $(window).resize on_ui_window_resize
  on_ui_window_resize()
  init_sidebar_search()