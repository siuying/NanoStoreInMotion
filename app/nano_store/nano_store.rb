module NanoStore  
  class NanoStoreError < StandardError; end

  def self.store
    error_ptr = Pointer.new(:id)
    store = NSFNanoStore.createAndOpenStoreWithType(NSFMemoryStoreType, path:nil, error: error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]    
    store
  end

  module InstanceMethods
    def save(store)
      error_ptr = Pointer.new(:id)
      store.addObject(self, error:error_ptr)
      raise NanoStoreError, error_ptr[0].description if error_ptr[0]
      self
    end
  
    def delete
      nil
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

  module ClassMethods
    def attribute(name)
      @attributes ||= []
      @attributes << name
    end
    
    def attributes
      @attributes ||= []
    end
  end

  class Model < NSFNanoObject
    include InstanceMethods
    extend ClassMethods
  end

end