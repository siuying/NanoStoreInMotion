require "bundler/gem_tasks"
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'
require 'motion-redgreen'

Motion::Project::App.setup do |app|
  app.name = 'NanoStoreDemo'
  app.redgreen_style = :full
  app.files += Dir.glob(File.join(app.project_dir, 'lib/nano_store/*.rb'))
  app.pods do
    pod 'NanoStore', '~> 2.1.8'
  end
end


desc "Build the gem"
task :gem do
  sh "bundle exec gem build nano-store.gemspec"
  sh "mkdir -p pkg"
  sh "mv *.gem pkg/"
end