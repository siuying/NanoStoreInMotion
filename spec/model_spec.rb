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
  
  it "find object" do
    user = stub_user("Bob", 10, Time.now)
    user.save
    
    users = User.find(:name, NSFEqualTo, "Bob")
    users.should.not.be.nil
    users.count.should == 1
    users.first.name.should == user.name
    
    users = User.find_keys(:name, NSFEqualTo, "Bob")
    users.should.not.be.nil
    users.count.should == 1
    users.first.should == user.key
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
  end
  
  it "find all objects" do
    user = stub_user("Bob", 10, Time.now)
    user.save
    
    user2 = stub_user("Amy", 11, Time.now)
    user2.save
  
    users = User.all
    users.size.should == 2
    users[0].key.should == user.key
    users[1].key.should == user2.key
  end

  it "search object" do
    user = stub_user("Bob", 10, Time.now)
    user.save
    
    user2 = stub_user("Amy", 11, Time.now)
    user2.save
  
    users = User.find(:name, NSFEqualTo, "Bob")
    users.should.not.be.nil
    user = users.first
    user.should.not.be.nil
    user.name.should.be == "Bob"
    user.age.should.be == 10
  end
end
