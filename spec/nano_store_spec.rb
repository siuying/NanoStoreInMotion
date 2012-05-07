describe NanoStore do
  
  class User
    include NanoStore
    
    attribute :name
    attribute :age
    attribute :created_at
  end
  
  def stub_user(name, age, created_at)
    user = User.new
    user.name = name
    user.age  = age
    user.created_at = created_at
    user
  end

  it "create new object" do
    store = NanoStore.store

    user = stub_user("Bob", 10, Time.now)
    user.save(store)

    user.attributes.keys.should.be.equal([:name, :age, :created_at])
    user.attributes.should.be.equal({name: "Bob", age: 10, created_at: user.created_at})
  end
  
  it "search object" do
    @store = NanoStore.store
    
    user = stub_user("Bob", 10, Time.now)
    user.save(@store)
    
    user2 = stub_user("Amy", 11, Time.now)
    user2.save(@store)

    search = NSFNanoSearch.searchWithStore(@store)
    search.attribute = "name"
    search.match = NSFEqualTo
    search.value = "Bob"

    error_ptr = Pointer.new(:id)
    searchResults = search.searchObjectsWithReturnType(NSFReturnObjects, error:error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]

    searchResults.should.not.be.nil
    user = searchResults.values.first
    user.should.not.be.nil
    user.name.should.be == "Bob"
    user.age.should.be == 10
  end
end
