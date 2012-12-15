module NanoStore
  module AssociationClassMethods
    def has_many(name, options={})
      @association_has_many ||= []
      @association_has_many << name

      define_method(name) do |*args, &block|
        @association_bags ||= {}
        return @association_bags[name] if @association_bags[name]

        bag_key = self.info[name]
        if bag_key.nil?
          bag = Bag.bag
          self.info[name] = bag.key
        else
          bag = self.class.store.bagsWithKeysInArray([bag_key]).first
        end

        @association_bags[name] = bag

        bag
      end

      define_method((name + "=").to_sym) do |*args, &block|
        bag = self.send(name)
        case args[0]
        when Bag
          bag.clear
          bag = bag + args[0].saved.values
        when Array
          bag.clear
          bag = bag + args[0]
        else
          raise NanoStoreError, "Unexpected type assigned to bags, must be an Array or NanoStore::Bag, now: #{args[0].class}"
        end
        bag
      end
    end

    def belongs_to(name, options={})
    end

    # TODO figure out why inherited here would break inherited in model.rb
    # def inherited(subclass)
    #   subclass.instance_variable_set(:@association_has_many, [])
    # end
  end

  module AssociationInstanceMethods
  end
  
end