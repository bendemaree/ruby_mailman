require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

desc 'prepare gem'
task :setup_development do
  `git clone https://github.umn.edu/umnapi/protobufs.git ./vendor/protobufs`
  `bundle exec rprotoc -p vendor/protobufs/ -o lib auth.proto`
  `bundle exec rprotoc -p vendor/protobufs/ -o lib route.proto`
end
