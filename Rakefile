$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  app.name = 'NanoStoreDemo'

  app.files = Dir.glob(File.join(app.project_dir, 'vendor/BubbleWrap/lib/**/*.rb')) + app.files
  app.files = Dir.glob(File.join(app.project_dir, 'vendor/NanoStoreInMotion/lib/**/*.rb')) + app.files
  app.pods do
    dependency 'NanoStore'
  end
end
