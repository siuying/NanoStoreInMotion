module NanoStore
  module FinderMethods    
    # find model by criteria
    #
    # Return array of models
    #
    # Examples:
    #   User.find(:name, NSFEqualTo, "Bob") # => [<User#1>]
    #   User.find(:name => "Bob") # => [<User#1>]
    #   User.find(:name => {NSFEqualTo => "Bob"}) # => [<User#1>]
    #
    def find(*arg)
      if arg[0].is_a?(Hash)
        # hash style
        options = arg[0]
      elsif arg[0] && arg[1] && arg[2]
        # standard way to find
        options = {arg[0] => {arg[1] => arg[2]}}
      end
      search = NSFNanoSearch.searchWithStore(self.store)
      expressions = expressions_with_options(options)
      search.setExpressions(expressions)
      error_ptr = Pointer.new(:id)
      searchResults = search.searchObjectsWithReturnType(NSFReturnObjects, error:error_ptr)
      raise NanoStoreError, error_ptr[0].description if error_ptr[0]
      searchResults.values
    end
    
    # find model keys by criteria
    #
    # Return array of keys
    #
    # Examples:
    #   User.find(:name, NSFEqualTo, "Bob") # => [<User#1>]
    #   User.find(:name => "Bob") # => [<User#1>]
    #   User.find(:name => {NSFEqualTo => "Bob"}) # => [<User#1>]
    #
    def find_keys(*arg)
      if arg[0].is_a?(Hash)
        # hash style
        options = arg[0]
      elsif arg[0] && arg[1] && arg[2]
        # standard way to find
        options = {arg[0] => {arg[1] => arg[2]}}
      end
      search = NSFNanoSearch.searchWithStore(self.store)
      expressions = expressions_with_options(options)
      search.setExpressions(expressions)
      error_ptr = Pointer.new(:id)
      searchResults = search.searchObjectsWithReturnType(NSFReturnKeys, error:error_ptr)
      raise NanoStoreError, error_ptr[0].description if error_ptr[0]
      searchResults
    end
    
    protected
    def expressions_with_options(options)
      expressions = []
      options.each do |key, val|
        attribute = NSFNanoPredicate.predicateWithColumn(NSFAttributeColumn, matching:NSFEqualTo, value:key.to_s)
        expression = NSFNanoExpression.expressionWithPredicate(attribute)

        if val.is_a?(Hash)
          val.each do |operator, sub_val|
            value = NSFNanoPredicate.predicateWithColumn(NSFValueColumn, matching:operator, value:sub_val)
            expression.addPredicate(value, withOperator:NSFAnd)
          end
        else
          value = NSFNanoPredicate.predicateWithColumn(NSFValueColumn, matching:NSFEqualTo, value:val)
          expression.addPredicate(value, withOperator:NSFAnd)
        end
        expressions << expression
      end
      return expressions
    end
  end # module FinderMethods
end # module NanoStore
