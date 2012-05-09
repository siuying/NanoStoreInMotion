describe NanoStore do
  it "create :memory store" do
    store = NanoStore.store
    store.filePath.should == ":memory:"

    store = NanoStore.store :memory
    store.filePath.should == ":memory:"
  end
  
  it "create :persistent store" do
    path = documents_path + "/nano.db"
    store = NanoStore.store :persistent, path
    store.filePath.should == path    

    path = documents_path + "/nano.db"
    store = NanoStore.store :file, path
    store.filePath.should == path
  end
  
  it "create :temp store" do
    store = NanoStore.store :temp
    store.filePath.should == ""

    store = NanoStore.store :temporary
    store.filePath.should == ""
  end

end
