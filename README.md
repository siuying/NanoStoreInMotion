# NanoStore for RubyMotion

Wrapper for NanoStore, a lightweight schema-less key-value document database based on sqlite, in RubyMotion.

Status: Work in progress. API subject to change.

## Installation

Add BubbleWrap, NanoStore and NanoStoreInMotion as a git submodule of your RubyMotion project:

    git clone https://github.com/mattetti/BubbleWrap.git vendor/BubbleWrap
    git clone https://github.com/tciuro/NanoStore.git vendor/NanoStore
    git clone https://github.com/siuying/NanoStoreInMotion.git vendor/NanoStoreInMotion

Add the lib path and NanoStore pod to your project 'Rakefile'

```ruby
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'
Motion::Project::App.setup do |app|
  app.name = 'myapp'
  app.files += Dir.glob(File.join(app.project_dir, 'vendor/BubbleWrap/lib/**/*.rb'))
  app.files += Dir.glob(File.join(app.project_dir, 'vendor/NanoStoreInMotion/lib/**/*.rb'))
  app.pods do
    dependency 'NanoStore'
  end
end
```

Now, you can use NanoStore in your app.

## Usage

### Set default storeage type

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

### Create

````ruby
user = User.nanoObject
user.name = name
user.age  = age
user.created_at = created_at
user.save
````
