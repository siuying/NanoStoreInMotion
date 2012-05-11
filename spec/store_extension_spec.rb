describe "StoreExtension" do
  it "should open and close store" do
    NanoStore.shared_store = NanoStore.store
    NanoStore.shared_store.open
    NanoStore.shared_store.closed?.should.be.false

    NanoStore.shared_store.close
    NanoStore.shared_store.closed?.should.be.true

    NanoStore.shared_store.open
    NanoStore.shared_store.closed?.should.be.false    
  end

end