require 'powerset'
require 'graph'
require 'u2_graph_search'

u2 = [:bono, :edge, :adam, :larry]
u2powerset = u2.powerset

graph = Graph.new
graph.add_vertex *u2powerset

p "All the " + graph.order.to_s + " vertexes added..."

i = 0
u2powerset.each do |v|
  u2powerset.each do |t|
    if v != t
      delta = (v.size - t.size).abs
      set_t = t.to_set
      set_v = v.to_set
      if delta >= 1 and delta <= 2 and (set_v.subset?(set_t) or set_t.subset?(set_v))
        graph.connect v, t
        i += 1
      end
    end
  end
end
p i.to_s + " connections added"

gs = GraphSearch.new graph

p "------"
search_result, possible_path = gs.search([], u2)
if search_result == :ok
  p "A path was discovered"
  p "It is:"
  possible_path.reverse_each { |v| p v}
else
  p "Sorry, no path found"
end
