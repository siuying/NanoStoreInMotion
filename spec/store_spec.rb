describe NanoStore do
  it "create store" do
    store = NanoStore.store
    store.filePath.should == ":memory:"

    store = NanoStore.store :memory
    store.filePath.should == ":memory:"

    # store = NanoStore.store :persistence, 
    # puts "path = " + store.filePath
#    store.filePath.should == ":memory:"
    
    
  end
end
