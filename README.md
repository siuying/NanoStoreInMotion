# NanoStore for RubyMotion

A wrapper for using NanoStore in RubyMotion.

Status: Work in progress. API subject to change.

## Usage

### Define Model

````ruby
class User < NanoStore::Model
  attribute :name
  attribute :age
  attribute :created_at
end
````

### Create

````ruby
store = NanoStore.store
user = User.nanoObject
user.name = name
user.age  = age
user.created_at = created_at
user.save(store)
````
