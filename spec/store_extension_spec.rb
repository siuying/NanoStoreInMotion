describe "StoreExtension" do
  before do
    NanoStore.shared_store = NanoStore.store
  end

  after do
    NanoStore.shared_store = nil
  end
  
  class Animal < NanoStore::Model
    attribute :name
  end

  it "should open and close store" do
    NanoStore.shared_store.open
    NanoStore.shared_store.closed?.should.be.false

    NanoStore.shared_store.close
    NanoStore.shared_store.closed?.should.be.true

    NanoStore.shared_store.open
    NanoStore.shared_store.closed?.should.be.false    
  end
  
  it "should add, delete objects and count them" do
    store = NanoStore.shared_store

    obj1 = Animal.new
    obj1.name = "Cat"
    obj2 = Animal.new
    obj2.name = "Dog"
    obj3 = Animal.new
    obj3.name = "Cow"
    obj4 = Animal.new
    obj4.name = "Duck"

    store << obj1
    store << [obj2, obj3]
    store += obj4

    store.save
    Animal.count.should == 4

    store.delete(obj1)
    Animal.count.should == 3

    store.delete_keys([obj2.key])
    Animal.count.should == 2

    store.clear
    Animal.count.should == 0
  end
  
  it "should discard unsave changes" do
    store = NanoStore.shared_store = NanoStore.store
    store.saveInterval = 1000 # must use setInterval to set auto save interval first
    store.engine.synchronousMode = SynchronousModeFull

    Animal.count.should == 0
    obj1 = Animal.new
    obj1.name = "Cat"
    obj2 = Animal.new
    obj2.name = "Dog"

    store << [obj1, obj2]
    store.changed?.should.be.true
    store.discard
    store.changed?.should.be.false
    Animal.count.should == 0    
  end

end