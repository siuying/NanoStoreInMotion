describe "Associations" do
  class Todo < NanoStore::Model
    attribute :title
    has_many :items
  end

  class TodoItem < NanoStore::Model
    attribute :completed
    attribute :text
  end
  
  before do
    NanoStore.shared_store = NanoStore.store
  end
  
  after do
    NanoStore.shared_store = nil
  end

  describe "#has_many" do
    it "adds a reader to the class" do
      todo = Todo.create(:title => "Today Tasks")
      todo.items.is_a?(NanoStore::Bag).should == true
      todo.items.size.should == 0
    end

    it "adds a writer to the class that take an array" do
      todo = Todo.create(:title => "Today Tasks")
      todo.items = [TodoItem.new(:text => "Hi"), TodoItem.new(:text => "Foo"), TodoItem.new(:text => "Bar")]
      todo.items.is_a?(NanoStore::Bag).should == true
      todo.items.size.should == 3
    end

    it "adds a writer to the class that take a Bag" do
      todo = Todo.create(:title => "Today Tasks")
      todo.items = NanoStore::Bag.bag
      todo.items.is_a?(NanoStore::Bag).should == true
      todo.items.size.should == 0
    end
  end

  describe "#save" do
    it "save a model also save associated fields" do
      todo = Todo.create(:title => "Today Tasks")
      todo.items = [TodoItem.new(:text => "Hi"), TodoItem.new(:text => "Foo"), TodoItem.new(:text => "Bar")]
      todo.items.is_a?(NanoStore::Bag).should == true
      todo.save

      todo2 = Todo.find(:title => "Today Tasks").first
      todo2.should.not.be.nil
      todo2.items.is_a?(NSFNanoBag).should == true
      todo2.items.key.should == todo.items.key
      todo2.items.size.should == 3
      todo2.items.to_a.each do |item|
        item.is_a?(TodoItem).should.be.true
      end
    end
  end

end
