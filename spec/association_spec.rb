describe "Associations" do
  class Todo < NanoStore::Model
    attribute :title
    has_many :items, :class_name => "TodoItem"
  end

  class TodoItem < NanoStore::Model
    attribute :completed
    attribute :text
    belongs_to :todo
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

    it "allow using << to add objects into association" do
      todo = Todo.create(:title => "Today Tasks")
      todo.items << TodoItem.new(:text => "Hello world!")
      todo.items.size.should == 1
    end
  end

end
