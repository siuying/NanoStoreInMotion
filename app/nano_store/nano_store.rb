module NanoStore
  class NanoStoreError < StandardError; end
  
  def self.store
    error_ptr = Pointer.new(:id)
    store = NSFNanoStore.createStoreWithType(NSFMemoryStoreType, path:nil)
    store.openWithError(error_ptr)
    raise NanoStoreError, error_ptr[0].description if error_ptr[0]    
    store
  end

  def self.included(base)
    base.instance_eval do
      include InstanceMethods
      extend ClassMethods
    end
  end
  private_class_method :included
  
  module InstanceMethods
    def attributes
      self.class.attributes.inject({}) do |attributes, key|
        attributes[key] = self.send(key)
        attributes
      end
    end
    
    def save(store)
      object = NSFNanoObject.nanoObject

      self.attributes.each do |key, value|
        object[key.to_s] = value
      end

      error_ptr = Pointer.new(:id)
      store.addObject(object, error:error_ptr)
      raise NanoStoreError, error_ptr[0].description if error_ptr[0]

      self
    end
  end

  module ClassMethods
    def attributes
      @attributes
    end

    def attribute(name)
      @attributes ||= []
      @attributes << name
      attr_accessor name
    end
  end

end