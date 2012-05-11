describe "StoreExtension" do
  before do
    NanoStore.shared_store = NanoStore.store    
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
  
  it "should add and remove objects" do
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
  end

end