describe NanoStore::Bag do  
  Bag = NanoStore::Bag

  class Page < NanoStore::Model
    attribute :text
    attribute :index
  end
  
  before do
    NanoStore.shared_store = NanoStore.store
  end
  
  after do
    NanoStore.shared_store = nil
  end

  it "should add objects to bag" do
    bag = Bag.bag

    # use << method to add object to bag
    page = Page.new
    page.text = "Hello"
    page.index = 1
    bag << page 
    
    # use + method to add object to bag
    page = Page.new
    page.text = "World"
    page.index = 2
    bag += page

    bag.unsaved.count.should.be == 2
    bag.changed?.should.be.true
    bag.save
     
    bag.unsaved.count.should.be == 0
    bag.saved.count.should.be == 2
    bag.changed?.should.be.false
  end

  it "should delete object from bag" do
    bag = Bag.bag

    # use << method to add object to bag
    page = Page.new
    page.text = "Hello"
    page.index = 1
    bag << page

    page = Page.new
    page.text = "Foo Bar"
    page.index = 2
    bag << page 

    bag.save
    bag.saved.count.should.be == 2
    bag.delete(page)
    bag.changed?.should.be.true
    bag.removed.count.should.be == 1
    bag.save
    bag.saved.count.should.be == 1
  end

  it "should add bag to store" do
    before_count = NanoStore.shared_store.bags.count

    bag = Bag.bag

    # use << method to add object to bag
    page = Page.new
    page.text = "Hello"
    page.index = 1
    bag << page 

    bag.save
    NanoStore.shared_store.bags.count.should.be == before_count + 1
  end
end