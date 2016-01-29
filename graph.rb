class Graph
  def initialize(init_hash={})
    @vertices = {}
    init_hash.each do |vertex, edges|
      add_vertex vertex, edges
    end
  end

  def vertices
    @vertices.keys
  end

  def add_vertex(vertex, edge_list=[])
    raise DuplicateVertexError unless @vertices[vertex].nil?
    @vertices[vertex] = edge_list
  end

  def edges_of(vertex)
    @vertices[vertex]
  end

  def path_between_vertices(start, dest, method=:dfs)
    nil
  end

  def valid_path?(vertex_list)
    vertex_list[0..-2].each_with_index do |vertex, index|
      return false unless has_edge?(vertex, vertex_list[index + 1])
    end
    true
  end

  def has_edge?(source,sink)
    if has_vertex?(source) and has_vertex?(sink) and edges_of(source).include? sink
      true
    else
      false
    end
  end

  def has_vertex?(vertex)
    @vertices.keys.include? vertex
  end

  private

  # def dfs(start, dest)
  #
  #
  # end

  class DuplicateVertexError < ArgumentError
  end
  class NoSuchVertexError < ArgumentError
  end
end