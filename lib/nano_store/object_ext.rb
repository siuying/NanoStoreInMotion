class NSFNanoObject
  def [](key)
    self.objectForKey(key)
  end

  def []=(key, val)
    self.setObject(val, forKey: key)
  end  
end