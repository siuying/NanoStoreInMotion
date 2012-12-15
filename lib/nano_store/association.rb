module NanoStore
  module AssociationClassMethods
    def has_many_options
      @has_many_options ||= {}
    end

    def has_many(name, options={})
      has_many_options[name] = options

      define_method(name) do |*args, &block|
        return has_many_bags[name] if has_many_bags[name]

        bag_key = self.info[name]
        if bag_key.nil?
          bag = Bag.bag
          self.info[name] = bag.key
        else
          bag = self.class.store.bagsWithKeysInArray([bag_key]).first
        end

        has_many_bags[name] = bag

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
    def has_many_bags
      @has_many_bags ||= {}
    end

    def save
      has_many_bags.values.each do |bag|
        bag.store = self.class.store
        bag.save
      end
      super
    end
  end
  
end