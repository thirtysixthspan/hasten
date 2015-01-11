require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :gem do

  task :build do
    `gem build jiragit.gemspec`
  end

  task :install => [:build] do
    `gem install pkg/jiragit*.gem`
  end

end
