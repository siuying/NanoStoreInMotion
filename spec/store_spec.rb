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

  it "should use shared_store if a model has no store defined" do  
    class TempModel < NanoStore::Model
    end

    NanoStore.shared_store = NanoStore.store
    TempModel.store.should.not.be.nil
    NanoStore.shared_store.should.not.be.nil
    TempModel.store.should == NanoStore.shared_store

    TempModel.store = NanoStore.store :temp
    TempModel.store.should.not == NanoStore.shared_store
  end

end
