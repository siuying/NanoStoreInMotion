describe NanoStore::Model do
  
  class User < NanoStore::Model
    attribute :name
    attribute :age
    attribute :created_at
  end
  
  def stub_user(name, age, created_at)
    user = User.nanoObject
    user.name = name
    user.age  = age
    user.created_at = created_at
    user
  end

  it "create new object" do
    store = NanoStore.store

    user = stub_user("Bob", 10, Time.now)
    user.save(store)

    user.info.keys.include?("name").should.be.true
    user.info.keys.include?("age").should.be.true
    user.info.keys.include?("created_at").should.be.true

    user.info["name"].should == "Bob"
    user.info["age"].should == 10
    user.info["created_at"].should == user.created_at

    user.name.should == "Bob"
    user.age.should == 10
  end

  it "search object" do
    store = NanoStore.store
    
    user = stub_user("Bob", 10, Time.now)
    user.save(store)
    
    user2 = stub_user("Amy", 11, Time.now)
    user2.save(store)
  
    search = NSFNanoSearch.searchWithStore(store)
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
