module NanoStore
  module AssociationClassMethods
    def bag(name)
      define_method(name) do |*args, &block|
        return _bags[name] if _bags[name]

        bag_key = self.info[name]
        if bag_key.nil?
          bag = Bag.bag
          self.info[name] = bag.key
        else
          bag = self.class.store.bagsWithKeysInArray([bag_key]).first
        end

        _bags[name] = bag

        bag
      end

      define_method((name + "=").to_sym) do |*args, &block|
        bag = self.send(name)
        case args[0]
        when Bag
          bag.clear
          bag += args[0].saved.values
        when Array
          bag.clear
          bag += args[0]
        else
          raise NanoStoreError, "Unexpected type assigned to bags, must be an Array or NanoStore::Bag, now: #{args[0].class}"
        end
        bag
      end
    end
  end

  module AssociationInstanceMethods
    def _bags
      @_bags ||= {}
    end

    def save
      _bags.values.each do |bag|
        bag.store = self.class.store
        bag.save
      end
      super
    end
  end
  
end