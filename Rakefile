require "bundler/gem_tasks"

task :default => [:test]

desc 'prepare gem'
task :setup_development do
  `git clone https://github.umn.edu/umnapi/protobufs.git ./vendor/protobufs`
  `bundle exec rprotoc -p vendor/protobufs/ -o lib auth.proto`
  `bundle exec rprotoc -p vendor/protobufs/ -o lib route.proto`
end

task :test do
  puts "Tests to come"
end
