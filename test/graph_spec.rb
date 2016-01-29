Bundler.require
require '../graph'

describe Graph do

  subject(:graph) { Graph.new }

  let(:full_graph) { Graph.new({a: [:b,:c,:d],
                                b: [:a],
                                c: [:a,:f],
                                d: [:a,:e,:f],
                                e: [:d],
                                f: [:c, :d]}) }
  let(:new_vertex) { :a }
  let(:edges) { [:b,:c] }

  it { is_expected.to respond_to :vertices }
  it { is_expected.to respond_to :add_vertex }
  it { is_expected.to respond_to :edges_of }
  it { is_expected.to respond_to :has_vertex? }
  it { is_expected.to respond_to :has_edge? }
  it { is_expected.to respond_to :valid_path? }
  it { is_expected.to respond_to :path_between_vertices }

  describe '#initialize' do
    context 'with arguments' do
      it 'creates a graph with the vertices and edges passed in' do
        hash_graph = { a: [:b,:c],
                       b: [:a],
                       c: [:d, :a],
                       d: [:c, :e],
                       e: [:d]      }
        new_graph = Graph.new hash_graph
        expect(new_graph.vertices).to eq(hash_graph.keys)
        hash_graph.keys.each do |vertex|
          expect(new_graph.edges_of(vertex)).to eq(hash_graph[vertex])
        end
      end
    end
  end

  describe 'vertex and edge methods' do

    describe '#add_vertex' do
      it 'increases the number of vertices by 1' do
        expect{graph.add_vertex(new_vertex)}.to change{graph.vertices.length}.by 1
      end
      context 'with no edges' do
        before(:each) do
          graph.add_vertex(new_vertex)
        end

        it 'adds the vertex passed as an argument' do
          expect(graph.vertices).to include new_vertex
        end

        it 'initializes the vertex with no edges' do
          expect(graph.edges_of(new_vertex)).to be_empty
        end
      end
      context 'with edges' do
        it 'initializes the vertex with the correct edges' do
          graph.add_vertex(new_vertex, edges)
          expect(graph.edges_of(new_vertex)).to eq edges
        end
      end
      it 'raises an error when adding a duplicate vertex' do
        graph.add_vertex new_vertex
        expect{graph.add_vertex(new_vertex)}.to raise_error(Graph::DuplicateVertexError)
      end
    end

    describe '#edges_of' do
      it 'returns the edges of a given vertex' do
        graph.add_vertex new_vertex, edges
        expect(graph.edges_of new_vertex).to eq edges
      end
    end

    describe '#has_vertex?' do
      it 'returns true when the graph contains the vertex' do
        graph.add_vertex new_vertex
        expect(graph.has_vertex? new_vertex).to equal true
      end

      it 'returns false when the graph does not contain the vertex' do
        expect(graph.has_vertex? new_vertex).to equal false
      end
    end
  end

  describe 'path methods' do
    describe '#has_edge?' do
      let(:graph) { full_graph }
      it 'returns false when given a vertex not in the graph' do
        expect(graph.has_edge?(:a,:x)).to eq false
      end

      it 'returns false when there is no such edge' do
        expect(graph.has_edge?(:a,:e)).to eq false
      end

      it 'returns true when there is such an edge' do
        expect(graph.has_edge?(:a,:c)).to eq true
      end
    end

    describe '#valid_path?' do
      let(:graph) { full_graph }
      it 'returns true on the empty path' do
        expect(graph.valid_path? []).to eq true
      end
      context 'on tree paths' do
        it 'returns true on a valid path' do
          path = [:b,:a,:c,:f,:d]
          expect(graph.valid_path? path).to eq true
        end
        it 'returns false on an invalid path' do
          path = [:b,:a,:c,:d]
          expect(graph.valid_path? path).to eq false
        end
      end
      context 'on cyclical paths' do
        it 'returns true on a valid path' do
          path = [:b,:a,:c,:f,:d,:a]
          expect(graph.valid_path? path).to eq true
        end

        it 'returns false on an invalid path' do
          path = [:b,:a,:c,:d,:a]
          expect(graph.valid_path? path).to eq false
        end
      end
    end

    describe '#path_between_vertices' do
      xit 'works' do

      end
    end
  end



end