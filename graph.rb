require 'set'

class InvalidVertexGiven < Exception; end

class Graph

  attr_reader :vertices

  def initialize
    @vertices = Set.new
    @connections = Hash.new
  end

  def add_vertex *v
    @vertices.merge v
  end

  def remove_vertex v
    @vertices.delete v
  end

  def connect v1, v2

    if !Set.new([v1, v2]).subset? @vertices
      raise InvalidVertexGiven, 'The Graph doesnt have at least one of the given vertices'
    end

    @connections[v1] ||= Array.new
    @connections[v1].push v2

    unless v1.eql? v2
      @connections[v2] ||= Array.new
      @connections[v2].push v1
    end
  end

  def disconnect v1, v2
    @connections[v1].delete v2
    @connections[v2].delete v1
  end

  def order
    @vertices.size
  end

  def adjacents v
    @connections[v]
  end

  def degree v
    d = 0
    if @connections[v].is_a? Array
      d = @connections[v].nitems
      if @connections[v].include?(v)
        d += 1
      end
    end
    d
  end

  def regular?
    @vertices.inject do |v1, v2|
      if self.degree(v1) != self.degree(v2)
        return false
      end
      v2
    end
    true
  end
end
