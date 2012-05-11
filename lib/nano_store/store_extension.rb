class NSFNanoStore
  def engine
    self.nanoStoreEngine
  end
  
  def changed?
    self.hasUnsavedChanges
  end

  ## Open and Close store

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
  
  ## Adding and Removing Objects

  def <<(objects)
    error_ptr = Pointer.new(:id)
    if objects.is_a?(Array)
      self.addObjectsFromArray(objects, error:error_ptr)
    else
      self.addObject(objects, error:error_ptr)
    end
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    self
  end
  
  def +(object)
    error_ptr = Pointer.new(:id)
    self.addObject(object, error:error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    self
  end
  
  # delete a object or array of objects from the array
  def delete(objects)
    error_ptr = Pointer.new(:id)
    if objects.is_a?(Array)
      result = self.removeObjectsInArray(objects, error:error_ptr)
    else
      result = self.removeObject(objects, error:error_ptr)
    end
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    result
  end
  
  # delete all objects from store
  def clear
    error_ptr = Pointer.new(:id)
    result = self.removeAllObjectsFromStoreAndReturnError(error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    result
  end
  
  # delete object with keys
  # param: keys - array of key
  def delete_keys(keys)
    error_ptr = Pointer.new(:id)
    result = self.removeObjectsWithKeysInArray(keys, error:error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    result    
  end

  ## Save and Maintenance
  
  # Saves the uncommitted changes to the document store.
  def save
    error_ptr = Pointer.new(:id)
    result = saveStoreAndReturnError(error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    result
  end
  
  # Discards the uncommitted changes that were added to the document store. 
  alias_method :discard, :discardUnsavedChanges
  
  # Compact the database file size.
  def compact
    error_ptr = Pointer.new(:id)
    result = self.compactStoreAndReturnError(error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    result
  end
  
  # Remove all indexes from the document store. 
  def clear_index
    error_ptr = Pointer.new(:id)
    result = self.clearIndexesAndReturnError(error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    result
  end

  # Recreate all indexes from the document store. 
  def rebuild_index
    error_ptr = Pointer.new(:id)
    result = self.rebuildIndexesAndReturnError(error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    result
  end
  
  # Makes a copy of the document store to a different location and optionally compacts it to its minimum size. 
  def save_store(path, compact=true)
    error_ptr = Pointer.new(:id)
    result = self.saveStoreToDirectoryAtPath(path, compactDatabase:compact, error:error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    result
  end

  # Count number of this class objects in store  
  def count(clazz)
    self.countOfObjectsOfClassNamed(clazz.to_s)
  end
  
  # Create a transaction
  def transcation
    error_ptr = Pointer.new(:id)
    beginTransactionAndReturnError(error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]

    begin
      yield self
    rescue e
      rollbackTransactionAndReturnError(error_ptr)
      raise e
    end
    success = commitTransactionAndReturnError(error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]
    success
  end

end