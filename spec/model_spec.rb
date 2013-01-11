describe NanoStore::Model do
  class User < NanoStore::Model
    attributes :name, :age, :created_at
  end

  class Plane < NanoStore::Model
    attributes :name, :age
  end

  class Listing < NanoStore::Model
    attribute :name
  end

  def stub_user(name, age, created_at)
    user = User.new
    user.name = name
    user.age  = age
    user.created_at = created_at
    user
  end
  
  before do
    NanoStore.shared_store = NanoStore.store
  end
  
  after do
    NanoStore.shared_store = nil
  end

  describe "::new" do
    it "create new object" do
      user = stub_user("Bob", 10, Time.now)
      user.save

      user.info.keys.include?("name").should.be.true
      user.info.keys.include?("age").should.be.true
      user.info.keys.include?("created_at").should.be.true

      user.info["name"].should == "Bob"
      user.info["age"].should == 10
      user.info["created_at"].should == user.created_at

      user.name.should == "Bob"
      user.age.should == 10
      User.count.should == 1
    end

    it "create object with nil field" do
      user = stub_user("Bob", 10, nil)
      user.save
      user.key.should.not.be.nil
    end

    it "throw error when invalid parameter" do
      lambda { 
        user = User.new(:name => "Eddie", :age => 12, :created_at => Time.now, :gender => "m")
      }.should.raise(::NanoStore::NanoStoreError)
    end

  end

  describe "::create" do
    it "create object with hash" do
      name = "Abby"
      age  = 30
      created_at = Time.now
      user = User.create(:name => name, :age => age, :created_at => created_at)
      user.name.should == name
      user.age.should == age
      user.created_at.should == created_at
    end
  end

  describe "#save" do
    it "if no store set, create objects using shared store" do
      user = stub_user("Bob", 10, Time.now)
      user.save
      NanoStore.shared_store.count(User).should == 1
    end

    # per object store since NanoStore 2.5.1
    it "user per instance store to save" do 
      store1 = NanoStore.store
      user = stub_user("Bob", 10, Time.now)
      user.store = store1
      user.save
      store1.count(User).should == 1

      store2 = NanoStore.store
      user2 = stub_user("Lee", 10, Time.now)
      user2.store = store2
      user2.save
      store2.count(User).should == 1
      store1.count(User).should == 1
    end

    it "update existing objects" do
      user = stub_user("Bob", 10, Time.now)
      user.save

      user1 = User.find(:name, NSFEqualTo, "Bob").first
      user1.name = "Dom"
      user1.save

      user2 = User.find(:name, NSFEqualTo, "Dom").first
      user2.key.should == user.key
    end

    it "create with nil field" do
      user = stub_user("Bob", 10, nil)
      user.save

      user1 = User.find(:name, NSFEqualTo, "Bob").first
      user1.name.should == "Bob"
      user1.created_at.should.be.nil
    end
  end
  
  describe "#delete" do
    it "delete object" do
      user = stub_user("Bob", 10, Time.now)
      user.save
      
      users = User.find(:name, NSFEqualTo, "Bob")
      users.should.not.be.nil
      users.count.should == 1
      
      user.delete
      users = User.find(:name, NSFEqualTo, "Bob")
      users.should.not.be.nil
      users.count.should == 0
      User.count.should == 0
    end
  end

  describe "::delete" do
    it "bulk delete" do
      user = stub_user("Bob", 10, Time.now)
      user.save
      
      user = stub_user("Ken", 12, Time.now)
      user.save

      user = stub_user("Kyu", 14, Time.now)
      user.save
      
      plane = Plane.create(:name => "A730", :age => 20)

      User.count.should == 3
      User.delete({:age => {NSFGreaterThan => 10}})
      User.count.should == 1

      User.delete({})
      User.count.should == 0
      Plane.count.should == 1
    end
  end
  
  describe "Issues" do
    # see github issue #15 
    # https://github.com/siuying/NanoStoreInMotion/issues/15
    it "should handle some class name with conflicts" do
      listing = Listing.new
      listing.name = "A"
      listing.save

      Listing.count.should == 1
      Listing.all.size.should == 1
    end
  end
  
end
