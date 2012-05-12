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
    
    def method_missing(method, *args)
      matched = method.to_s.match(/^([^=]+)(=)?$/)
      name = matched[1]
      modifier = matched[2]

      if self.class.attributes.include?(name.to_sym) || name == "_id"
        if modifier == "="
          self.info[name.to_sym] = args[0]
        else
          self.info[name.to_sym]
        end
      else
        super
      end
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
    
    def all
      search = NSFNanoSearch.searchWithStore(self.store)
      error_ptr = Pointer.new(:id)
      searchResults = search.searchObjectsWithReturnType(NSFReturnObjects, error:error_ptr)
      raise NanoStoreError, error_ptr[0].description if error_ptr[0]
      searchResults.values
    end
    
    # find model by criteria
    #
    # Return array of models
    #
    # Example:
    #
    #   User.find(:name, NSFEqualTo, "Bob") => [<User#1>]
    #
    def find(attribute, match, value)
      search = search_with_store(self.store, attribute, match, value)
      error_ptr = Pointer.new(:id)
      searchResults = search.searchObjectsWithReturnType(NSFReturnObjects, error:error_ptr)
      raise NanoStoreError, error_ptr[0].description if error_ptr[0]
      searchResults.values
    end
    
    # find model keys by criteria
    #
    # Return array of model keys
    #
    # Example:
    #
    #   User.find(:name, NSFEqualTo, "Bob") => [<User#1>]
    #
    def find_keys(attribute, match, value)
      search = search_with_store(self.store, attribute, match, value)
      error_ptr = Pointer.new(:id)
      searchResults = search.searchObjectsWithReturnType(NSFReturnKeys, error:error_ptr)
      raise NanoStoreError, error_ptr[0].description if error_ptr[0]
      searchResults
    end

    def inherited(subclass)
      subclass.instance_variable_set(:@attributes, [])
      subclass.instance_variable_set(:@store, nil)
    end
    
    private
    def search_with_store(store, attribute, match, value)
      search = NSFNanoSearch.searchWithStore(self.store)
      search.attribute = attribute.to_s
      search.match = match
      search.value = value
      search
    end
  end

  class Model < NSFNanoObject
    include ModelInstanceMethods
    extend ModelClassMethods
  end
end