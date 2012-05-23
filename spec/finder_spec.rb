describe "Finder" do
  def stub_user(name, age, created_at)
    user = User.new
    user.name = name
    user.age  = age
    user.created_at = created_at
    user
  end

  after do
    NanoStore.shared_store = nil
  end
  
  before do
    NanoStore.shared_store = NanoStore.store

    user = stub_user("Bob", 10, Time.now)
    user.save
      
    user2 = stub_user("Amy", 11, Time.now)
    user2.save
    
    user3 = stub_user("Carl", 4, Time.now)
    user3.save
  end
  
  it "search object traditional way: supply key, operator and value" do
    users = User.find(:name, NSFEqualTo, "Bob")
    users.should.not.be.nil
    user = users.first
    user.should.not.be.nil
    user.name.should.be == "Bob"
    user.age.should.be == 10
  end

  it "search object with simple hash" do
    user = User.find(:name => "Carl").first
    user.name.should.be == "Carl"
    user.age.should.be == 4
  end

  it "search object with multiple parameters" do
    stub_user("Ronald", 18, Time.now).save
    stub_user("Ronald", 29, Time.now).save
    stub_user("Ronald", 36, Time.now).save
    stub_user("Ronald", 39, Time.now).save
    stub_user("Ronald", 49, Time.now).save
    stub_user("Ronald", 59, Time.now).save

    users = User.find(:name => { NSFEqualTo => "Ronald" }, :age => { NSFGreaterThan => 50 })
    users.size.should == 1
    user = users.first
    user.name.should.be == "Ronald"
    user.age.should.be == 59
    
    users = User.find(:name => { NSFEqualTo => "Ronald" }, :age => { NSFLessThan => 30 })
    users.size.should == 2    
    user = users.first
    user.name.should.be == "Ronald"
  end

  it "find object" do
    user = User.find(:name, NSFEqualTo, "Bob").first
    user.name.should == "Bob"
  end
  
end