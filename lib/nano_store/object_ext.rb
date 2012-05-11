class NSFNanoObject
  def [](key)
    self.objectForKey(key)
  end

  def []=(key, val)
    self.setObject(val, forKey: key)
  end  
end

class NSFNanoStore
  def close
    error_ptr = Pointer.new(:id)
    closed = self.closeWithError(error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    closed
  end
  
  def open
    error_ptr = Pointer.new(:id)
    opened = self.openWithError(error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    opened
  end
  
  def closed?
    self.isClosed
  end
end
