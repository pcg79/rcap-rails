class ObjectWithCollection
  include Validation
  attr_accessor( :collection )
  validates_collection_of( :collection )
  def initialize
    @collection = []
  end
end


describe( Validation::ClassMethods ) do
  describe( 'validates_collection_of' ) do
    before( :each ) do
      @object_with_collection = ObjectWithCollection.new
    end

    it( 'should be valid if all the members are valid' ) do
      @object_with_collection.collection = Array.new(3){ CAP::Point.new( 0, 0 )}
      @object_with_collection.should( be_valid )
    end

    it( 'should not be valid some of the members are invalid' ) do
      @object_with_collection.collection = Array.new( 2 ){ CAP::Point.new( 0, 0 )} + [ CAP::Point.new( "not a number",0)]
      @object_with_collection.should_not( be_valid )
    end
  end
end
