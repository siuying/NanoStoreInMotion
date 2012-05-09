# NanoStore for RubyMotion

Using NanoStore, a lightweight schema-less key-value document database based on sqlite, in RubyMotion.

Status: Work in progress. API subject to change.

## Installation

Add BubbleWrap and NanoStore as a git submodule of your RubyMotion project:

    git clone https://github.com/mattetti/BubbleWrap.git vendor/BubbleWrap
    git clone https://github.com/siuying/NanoStoreInMotion.git vendor/NanoStoreInMotion

Add the lib path to your project 'Rakefile'

```ruby
Motion::Project::App.setup do |app|
  app.name = 'myapp'
  app.files += Dir.glob(File.join(app.project_dir, 'vendor/BubbleWrap/lib/**/*.rb'))
  app.files += Dir.glob(File.join(app.project_dir, 'vendor/NanoStoreInMotion/lib/**/*.rb'))
end
```

Now, you can use NanoStore in your app.

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
