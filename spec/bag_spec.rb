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
    NanoStore.shared_store.addObject(bag, error:nil)

    page = Page.new
    page.text = "Hello"
    page.index = 1
    bag << page
    
    page = Page.new
    page.text = "World"
    page.index = 2
    bag << page
    
    bag.unsaved.count.should.be == 2
    bag.changed?.should.be.true
    bag.save
     
    bag.unsaved.count.should.be == 0
    bag.saved.count.should.be == 2
    bag.changed?.should.be.false
  end
end