require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'
require 'bubble-wrap'
require 'motion-redgreen'

Motion::Project::App.setup do |app|
  app.name = 'NanoStoreDemo'

  app.files += Dir.glob(File.join(app.project_dir, 'lib/nano_store/*.rb'))
  app.pods do
    dependency 'NanoStore'
  end
end