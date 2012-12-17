# NanoStore for RubyMotion

Wrapper for NanoStore, a lightweight schema-less key-value document database based on sqlite, in RubyMotion.

Status: Work in progress. API subject to change.

## Installation

Install the CocoaPods dependency manager if you haven't it already:

    gem install motion-cocoapods
    pod setup
    
Install nano-store gem

    gem install nano-store

Require nano-store to your project 'Rakefile'

```ruby
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'rubygems'
require 'motion-cocoapods'
require 'nano-store'

Motion::Project::App.setup do |app|
  app.name = 'myapp'
  
  # Add the pod NanoStore to your project
  app.pods do
    pod 'NanoStore', '~> 2.1.8'
  end
end
```

Now, you can use NanoStore in your app.

## Basic Usage

### Set default storage type

````ruby
NanoStore.shared_store = NanoStore.store(:memory) # memory only db
NanoStore.shared_store = NanoStore.store(:file, documents_path + "/nano.db") # persist the data
````

### Define Model

````ruby
class User < NanoStore::Model
  attribute :name
  attribute :age
  attribute :created_at
end
````

A key (UUID) that identifies the object will be added automatically.

Attributes must be serializable, which means that only the following data types are allowed: 

- NSArray
- NSDictionary
- NSString
- NSData (*)
- NSDate
- NSNumber

#### Note

(*) The data type NSData is allowed, but it will be excluded from the indexing process.

### Create

````ruby
# Initialize a new object and save it
user = User.new(:name => "Bob", :age => 16, :created_at => Time.now)
user.save
user.key # => "550e8400-e29b-41d4-a716-446655440000" (automatically generated UUID)

# Create a new object directly
user = User.create(:name => "Bob", :age => 16, :created_at => Time.now)
````

### Retrieve

````ruby
# find all models
User.all # => [<User#1>, <User#2>]

# find model by criteria
users = User.find(:name, NSFEqualTo, "Bob")

# or use Hash
users = User.find(:name => "Bob")
users = User.find(:name => { NSFEqualTo => "Ronald" })
users = User.find(:name => { NSFEqualTo => "Ronald" }, :age => { NSFGreaterThan => 50 })

# or use Array for matching multiple values
users = User.find(:name => ["Bob", "Ronald", "Ken"])

# Optionally sort the result with additional hash parameters
users = User.find({:age => { NSFGreaterThan => 10 }}, {:sort => {:age => :desc}})
````

### Update

````ruby
user = User.find(:name, NSFEqualTo, "Bob").first
user.name = "Dom"
user.save
````

### Delete

````ruby
user = User.find(:name, NSFEqualTo, "Bob").first
user.delete

# Bulk delete
User.delete(:age => {NSFGreaterThan => 20})
````

## Using Transaction

Use transaction is easy, just wrap your database code in a transaction block.

```ruby
store = NanoStore.shared_store = NanoStore.store

begin
  store.transaction do |the_store|
    Animal.count # => 0
    obj1 = Animal.new
    obj1.name = "Cat"
    obj1.save
      
    obj2 = Animal.new
    obj2.name = "Dog"
    obj2.save
    Animal.count # => 2
    raise "error"  # => an error happened!
  end
rescue
  # error handling
end

Animal.count # => 0
```

## Using Bags

A bag is a loose collection of objects stored in a document store.

```ruby
store = NanoStore.store
bag = Bag.bag
store << bag

# add subclass of NanoStore::Model object to bag
page = Page.new
page.text = "Hello"
page.index = 1
bag << page 
    
# save the bag
bag.save
  
# obtain the bags from document store
bags = store.bags
```

### Association

Use ```bag``` to declare a Bag that associated with a Model. 

````ruby

class User < NanoStore::Model
  attribute :name
  attribute :age
  attribute :created_at
  bag :cars
end

class Car < NanoStore::Model
  attribute :name
  attribute :age
end

user = User.new(:name => "Peter", :age => 20, :created_at => Time.now)
user.cars << Car.new(:name => "Mini", :age => 0)
user.save

user.cars # => #<NanoStore::Bag:0x7411410> 
````

## Performance Tips

NanoStore by defaults saves every object to disk one by one. To speed up inserts and edited objects, increase NSFNanoStore's ```saveInterval``` property.

### Example

```ruby
# Create a store
store = NanoStore.shared_store = NanoStore.store
    
# Increase the save interval
store.save_interval = 1000

# Do a bunch of inserts and/or edits
obj1 = Animal.new
obj1.name = "Cat"
store << obj1

obj2 = Animal.new
obj2.name = "Dog"
store << obj2

# Don't forget that some objects could be lingering in memory. Force a save.
store.save
```

Note: If you set the saveInterval value to anything other one, keep in mind that some objects may still be left unsaved after being added or modified. To make sure they're saved properly, call:

```ruby
store.save
```

Choosing a good saveInterval value is more art than science. While testing NanoStore using a medium-sized dictionary (iTunes MP3 dictionary) setting saveInterval to 1000 resulted in the best performance. You may want to test with different numbers and fine-tune it for your data set.

## Credit

- Based on [NanoStore](https://github.com/tciuro/NanoStore) from Tito Ciuro, Webbo, L.L.C.

## License

BSD License