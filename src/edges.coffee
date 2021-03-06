_ = require 'underscore'

this.Edges = class Edges

  constructor: ->
    @edges = {}

  exists: (source, sink)->
    return @edges?[source]?[sink]? or @edges?[source]?[sink]?

  add: (source, sink)->
    if @exists(source, sink)
      @edges[source][sink] = (@edges[source][sink] + 1)|0
      @edges[sink][source] = (@edges[sink][source] + 1)|0
    else
      @set(source, sink, 1)

  set: (source, sink, cost)->
    if not source or not sink
      return throw Error("Invalid arguments. sourceId and sinkId is required.")

    if @exists(source, sink)
      @edges[source][sink] = cost|0
      @edges[sink][source] = cost|0
    else
      @edges[source] ||= {}
      @edges[source][sink] = cost|0
      @edges[sink] ||= {}
      @edges[sink][source] = cost|0

  getSinkNodes: (source)->
    if not @edges[source]
      return []
    else
      result = []
      nodes = Object.keys(@edges[source])
      nodes.forEach (sink)=>
        result.push sink if @edges[source][sink] > 0
      result


  setSelfLoop: (nodes)->

    nodes.forEach (source)=>
      nodes.forEach (sink)=>
        if source is sink
          @edges[source][sink] ||= 1

  getPendants: (nodes)->

    result = {}
    nodes.forEach (source)=>
      costed = []
      _.each @edges[source], (cost, sink)->
        return if nodes.indexOf(sink) is -1
        return if source is sink
        costed.push sink if cost > 0
      if costed.length is 1
        sink = costed[0]
        result[sink] ||= []
        result[sink].push source
    result

  generateMatrix: (nodes)->
    result = {}
    nodes.forEach (source)=>
      nodes.forEach (sink)=>
        result[source] ||= {}
        result[source][sink] = (@edges[source][sink] || 0)|0
    result

  getIsolated: (nodes)->
    result = []
    nodes.forEach (source)=>
      costed = []
      _.each @edges[source], (cost, sink)->
        return if nodes.indexOf(sink) is -1
        return if source is sink
        costed.push sink if cost > 0
      result.push source if costed.length is 0
    result

  avarageDegrees: (nodes)->
    total = 0
    nodes.forEach (source)=>
      _.each @edges[source], (cost, sink)=>
        return if not _.contains nodes, sink
        return if source is sink
        total = total + 1 if cost > 0
    total / nodes.length
