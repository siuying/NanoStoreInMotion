describe NanoStore::Model do
  
  class User < NanoStore::Model
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
  
  before do
    NanoStore.shared_store = NanoStore.store
  end
  
  after do
    NanoStore.shared_store = nil
  end

  it "create object" do
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

  it "create object with initializer" do
    name = "Abby"
    age  = 30
    created_at = Time.now
    user = User.create(:name => name, :age => age, :created_at => created_at)
    user.name.should == name
    user.age.should == age
    user.created_at.should == created_at
  end
  
  it "throw error when invalid parameter on initialize" do
    lambda { 
      user = User.new(:name => "Eddie", :age => 12, :created_at => Time.now, :gender => "m")
    }.should.raise(::NanoStore::NanoStoreError)
  end

  it "update objects" do
    user = stub_user("Bob", 10, Time.now)
    user.save

    user1 = User.find(:name, NSFEqualTo, "Bob").first
    user1.name = "Dom"
    user1.save

    user2 = User.find(:name, NSFEqualTo, "Dom").first
    user2.key.should == user.key
  end
  
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
  
  
  it "bulk delete" do
    user = stub_user("Bob", 10, Time.now)
    user.save
    
    user = stub_user("Ken", 12, Time.now)
    user.save

    user = stub_user("Kyu", 14, Time.now)
    user.save

    User.count.should == 3
    User.delete({:age => {NSFGreaterThan => 10}})
    User.count.should == 1
  end
  
  
end
