class GraphSearch

  def initialize graph
    @graph = graph
    @stack = []
    @path = []
  end

  def search seek_for, starting_at

    result, found = self.depth_search(seek_for, starting_at, true)
    if result == :ok
      return result, @path.push(starting_at)
    end

    false
  end

  def depth_search seek_for, starting_at, going

    @stack.push starting_at

    return :ok, starting_at if starting_at == seek_for

    all_ways = @graph.adjacents(starting_at)
    unless all_ways.nil?

      if going
        possible_ways = all_ways.select { |v| v.size < starting_at.size}
      else
        possible_ways = all_ways.select { |v| v.size > starting_at.size}
      end

      going = !going

      possible_ways.each do |vertex|

        if not @stack.include? vertex
          result, found = self.depth_search seek_for, vertex, going
          if result == :ok
            @path.push found
            return result, starting_at
          end
        end
      end
    end

    return :not_here, nil
  end
end
