require 'metric_fu'
require 'rake'
require 'rspec/core'
require 'rspec/core/rake_task'

desc "Run all specs in spec directory"

Rspec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "examples/**/*_spec.rb"
end

MetricFu::Configuration.run do |config|
  config.churn    = { :start_date => "1 year ago", :minimum_churn_count => 10}
  config.hotspots = { :start_date => "1 year ago", :minimum_churn_count => 10}
end

task :default => :spec

task :metrics => :"metrics:all"