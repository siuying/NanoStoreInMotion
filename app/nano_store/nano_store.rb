module NanoStore  
  class NanoStoreError < StandardError; end

  def self.store(type=:memory, path=nil)
    error_ptr = Pointer.new(:id)

    case type
    when :memory
      store = NSFNanoStore.createAndOpenStoreWithType(NSFMemoryStoreType, path:nil, error: error_ptr)
    when :temporary
      store = NSFNanoStore.createAndOpenStoreWithType(NSFTemporaryStoreType, path:nil, error: error_ptr)
    when :persistent
      store = NSFNanoStore.createAndOpenStoreWithType(NSFPersistentStoreType, path:path, error: error_ptr)
    else
      raise NanoStoreError.new('unexpected store type, must be one of: :memory, :temporary or :persistent')
    end

    raise NanoStoreError, error_ptr[0].description if error_ptr[0]    
    store
  end
  
  def self.shared_store
    @shared_store
  end
  
  def self.shared_store=(store)
    @shared_store = store
  end

end