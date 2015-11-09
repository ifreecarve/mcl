{ MCL } = require './mcl'
assert = require 'assert'

describe "mcl", ->

  context "with regular case", ->

    context "without option", ->
      it "returns clustered node array", ->
        mcl = new MCL
        setTemplateEdges(mcl)
        clustered = mcl.clustering()

        assert.deepEqual clustered, [
          [ 'alice', 'bob', 'carol', 'dave' ],
          [ 'silva', 'nasri', 'toure', 'kun', 'hart']
        ]

    context "with subgraph option", ->
      it "returns segmented and clustered node array", ->
        mcl = new MCL
        setTemplateEdges(mcl)
        clustered = mcl.clustering('alice')
        assert.deepEqual clustered, [ ['bob', 'carol'], ['hart'] ]


setTemplateEdges = (mcl)->
  mcl.setEdge 'alice', 'bob', 1
  mcl.setEdge 'alice', 'carol', 3
  mcl.setEdge 'bob', 'dave', 2
  mcl.setEdge 'carol', 'bob', 5
  mcl.setEdge 'bob', 'alice', 3

  mcl.setEdge 'silva', 'nasri', 10
  mcl.setEdge 'toure', 'silva', 7
  mcl.setEdge 'nasri', 'toure', 4
  mcl.setEdge 'kun', 'silva', 3
  mcl.setEdge 'hart', 'toure', 5
  mcl.setEdge 'hart', 'alice', 1


