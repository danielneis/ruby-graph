require 'graph'

describe Graph do

  before :each do
    @g = Graph.new
  end

  it 'should start with order 0' do
    @g.order.should == 0

    @g.vertices.empty?.should be_true
  end

  it 'should increment order if i add vertices' do
    @g.add_vertex :a
    @g.order.should == 1

    @g.add_vertex :b
    @g.order.should == 2

    @g.vertices.empty?.should be_false
    @g.vertices.should have(2).items
  end

  it 'should not store same vertex twice' do
    @g.add_vertex :a
    @g.add_vertex :a
    @g.order.should == 1
  end

  it 'should allow me to add more than one vertex at same call' do
    v1 = 'a vertex'
    v2 = 'another vertex'
    v3 = 'also another vertex'

    @g.add_vertex v1, v2, v3
  end

  it 'should decrement order if i remove vertices' do
    @g.add_vertex :a
    @g.add_vertex :b

    @g.remove_vertex :a
    @g.order.should == 1

    @g.vertices.should have(1).items

    @g.remove_vertex :b
    @g.order.should == 0

    @g.vertices.empty?.should be_true
  end

  it 'should store the degree of a vertex, which starts with 0' do
    v =  :a
    @g.add_vertex v
    @g.degree(v).should == 0
  end

  it 'should should increment degree of both vertices after a connection' do
    v1 = 'a vertex'
    v2 = 'another vertex'

    @g.add_vertex v1
    @g.add_vertex v2

    @g.connect v1, v2

    @g.degree(v1).should == 1
    @g.degree(v2).should == 1
  end

  it 'should decrement degree of both vertices after a connection' do
    v1 = 'a vertex'
    v2 = 'another vertex'

    @g.add_vertex v1, v2

    @g.connect v1, v2
    @g.disconnect v1, v2

    @g.degree(v1).should == 0
    @g.degree(v2).should == 0
  end

  it 'should let me connect the same vertex to two others' do
    v1 = 'a vertex'
    v2 = 'another vertex'
    v3 = 'also another vertex'

    @g.add_vertex v1, v2, v3

    @g.connect v1, v2
    @g.connect v1, v3

    @g.degree(v1).should == 2
    @g.degree(v2).should == 1
    @g.degree(v3).should == 1
  end

  it 'should not let me connect two vertices if it doesnt have both' do
    v1 = 'a vertex'
    v2 = 'another vertex'
    v3 = 'also another vertex'
    v4 = 'crazy vertex'


    @g.add_vertex v1, v2, v3

    lambda { @g.connect(v1, v4) }.should raise_error(InvalidVertexGiven, 'The Graph doesnt have at least one of the given vertices')
  end

  it 'should let met know the adjacents of a vertex' do
    v1 = 'a vertex'
    v2 = 'another vertex'
    v3 = 'one another vertex'
    v4 = 'also another vertex'
    v5 = 'the lonely vertex'

    @g.add_vertex v1, v2, v3, v4, v5

    @g.connect v1, v1
    @g.connect v1, v2
    @g.connect v1, v3
    @g.connect v2, v3
    @g.connect v2, v4

    @g.adjacents(v1).should == [v1, v2, v3]
    @g.adjacents(v2).should == [v1, v3, v4]
    @g.adjacents(v3).should == [v1, v2]
    @g.adjacents(v4).should == [v2]
    @g.adjacents(v5).should be_nil 
  end

  it 'should increment by two the order of a vertex after insert a loop' do
    v1 = 'a vertex'
    @g.add_vertex v1
    @g.connect v1, v1
    @g.degree(v1).should == 2
  end

  it 'should add just one connection after insert a loop' do
    v1 = 'a vertex'
    @g.add_vertex v1
    @g.connect v1, v1
    @g.adjacents(v1).should == [v1]
  end

  it 'should be regular if all vertices has the same degree' do
    v1 = 'a vertex'
    v2 = 'a second vertex'
    v3 = 'another vertex'
    v4 = 'one another vertex'

    @g.add_vertex v1
    @g.regular?.should be_true

    @g.add_vertex v2, v3, v4
    @g.regular?.should be_true

    @g.connect v1, v2
    @g.regular?.should be_false

    @g.connect v3, v4

    @g.regular?.should be_true

    @g.connect v1, v1
    @g.regular?.should be_false

    @g.connect v2, v2
    @g.connect v3, v3
    @g.regular?.should be_false

    @g.connect v4, v4
    @g.regular?.should be_true
  end

  it 'should handle arrays as vertices as well' do
    v1 = []
    v2 = [:a]
    v3 = [:a , :b]
    v4 = [1, 3 ,4]

    @g.add_vertex v1, v2, v3 ,v4

    @g.connect v1, v4
    @g.connect v2, v4
    @g.degree(v1).should == 1
    @g.degree(v2).should == 1
    @g.degree(v4).should == 2

    @g.adjacents(v1).should == [[1, 3, 4]]

    @g.disconnect v1, v4
    @g.degree(v1).should == 0
    @g.degree(v4).should == 1

    @g.adjacents(v1).should == []
  end
end
