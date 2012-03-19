define [
  'jQuery',
  'Underscore', 
  'Backbone',
  'order!threenodes/views/TreeView',
], ($, _, Backbone) ->
  "use strict"
  ### Sidebar View ###
  
  class ThreeNodes.Sidebar extends Backbone.View
    initialize: () ->
      super
      @initNewNode()
      @initSearch()
      @initTabs()
      @initTreeView()
    
    initTreeView: () =>
      @treeview = new ThreeNodes.TreeView
        el: $("#tab-list")
      return this
    
    initTabs: () =>
      @$el.tabs
        fx:
          opacity: 'toggle'
          duration: 100
      return this
    
    # Display fields attributes in sidebar when nodes are selected
    renderNodesAttributes: (nodes) =>
      # Always start with an empty element
      $target = $("#tab-attribute")
      $target.html("");
      
      # If there is no nodes to show abort now
      if !nodes || nodes.length < 1
        return this
      
      for node in nodes
        $target.append("<h2>#{node.get('name')}</h2>")
        for f of node.rack.node_fields.inputs
          node.rack.node_fields.inputs[f].render_sidebar()
      return this
    
    filter_list_item: ($item, value) =>
      s = $.trim($("a", $item).html()).toLowerCase()
      if s.indexOf(value) == -1
        $item.hide()
      else
        $item.show()
    
    filter_list: (ul, value) =>
      self = this
      ul_title = ul.prev()
      has_visible_items = false
      
      $("li", ul).each () -> self.filter_list_item($(this), value)
      
      if $("li:visible", ul).length == 0
        ul_title.hide()
      else
        ul_title.show()
      return this
    
    initSearch: () =>
      self = this
      $("#node_filter").keyup (e) ->
        v = $.trim($("#node_filter").val()).toLowerCase()
        if v == ""
          $("#tab-new li, #tab-new h3").show()
        else
          $("#tab-new ul").each () -> self.filter_list($(this), v)
      return this
                  
    initNewNode: () =>
      self = this
      $container = $("#tab-new")
      result = []
      nodes_by_group = {}
      
      # Organize each node types by group
      for node of ThreeNodes.nodes
        # don't show hidden nodes types (group_name = false)
        if ThreeNodes.nodes[node].group_name
          group_name = (ThreeNodes.nodes[node].group_name).replace(/\./g, "-")
          if !nodes_by_group[group_name]
            nodes_by_group[group_name] = []
          nodes_by_group[group_name].push(node)
      
      # Render the buttons and add them to the dom
      for group of nodes_by_group
        $container.append("<h3>#{group}</h3><ul id='nodetype-#{group}'></ul>")
        for node in nodes_by_group[group]
          $("#nodetype-#{group}", $container).append("<li><a class='button' rel='#{node}' href='#'>#{ ThreeNodes.nodes[node].node_name }</a></li>")
      
      # Make the list of nodes draggable
      $("a.button", $container).draggable
        revert: "valid"
        opacity: 0.7
        helper: "clone"
        revertDuration: 0
        scroll: false
        containment: "document"
      
      # Setup the drop area for the draggables created above
      $("#container").droppable
        accept: "#tab-new a.button"
        activeClass: "ui-state-active"
        hoverClass: "ui-state-hover"
        drop: (event, ui) ->
          nodename = ui.draggable.attr("rel")
          offset = $("#container-wrapper").offset()
          dx = ui.position.left + $("#container-wrapper").scrollLeft() - offset.left - 10
          dy = ui.position.top + $("#container-wrapper").scrollTop() - $("#sidebar").scrollTop() - offset.top
          ThreeNodes.events.trigger("CreateNode", {type: nodename, x: dx, y: dy})
          $("#sidebar").show()
      return this