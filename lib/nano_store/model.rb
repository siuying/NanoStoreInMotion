module NanoStore
  module ModelInstanceMethods
    def save
      raise NanoStoreError, 'No store provided' unless self.class.store

      error_ptr = Pointer.new(:id)
      self.class.store.addObject(self, error:error_ptr)
      raise NanoStoreError, error_ptr[0].description if error_ptr[0]
      self
    end
  
    def delete
      raise NanoStoreError, 'No store provided' unless self.class.store

      error_ptr = Pointer.new(:id)
      self.class.store.removeObject(self, error: error_ptr)
      raise NanoStoreError, error_ptr[0].description if error_ptr[0]
      self
    end
  end

  module ModelClassMethods
    # initialize a new object
    def new(data={})
      extra_keys = (data.keys - self.attributes)
      if extra_keys.size > 0
        raise NanoStoreError, "fields #{extra_keys.join(', ')} is not a defined fields"
      end

      object = self.nanoObjectWithDictionary(data)
      object
    end
    
    # initialize a new object and save it
    def create(data={})
      object = self.new(data)
      object.save
    end

    def attribute(name)
      @attributes << name

      define_method(name) do |*args, &block|
        self.info[name]
      end

      define_method((name + "=").to_sym) do |*args, &block|
        if args[0].nil?
          self.info.delete(name.to_sym)
        else
          self.info[name] = args[0]
        end
      end
    end
    
    def attributes
      @attributes
    end

    def store
      if @store.nil?
        return NanoStore.shared_store 
      end
      @store
    end

    def store=(store)
      @store = store
    end
    
    def count
      self.store.count(self)
    end
    
    def delete(*args)
      keys = find_keys(*args)
      self.store.delete_keys(keys)
    end

    def inherited(subclass)
      subclass.instance_variable_set(:@attributes, [])
      subclass.instance_variable_set(:@store, nil)
    end
  end

  class Model < NSFNanoObject
    include ModelInstanceMethods
    extend ModelClassMethods
    extend ::NanoStore::FinderMethods
  end
end