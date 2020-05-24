require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require_relative 'lib/mn2sts/version'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require 'open-uri'

file 'bin/mn2sts.jar' do |file|
  ver = Mn2sts::MN2STS_JAR_VERSION
  url = "https://github.com/metanorma/mn2sts/releases/download/v#{ver}/mn2sts-#{ver}.jar"
  File.open(file.name, 'wb') do |file|
    file.write open(url).read
  end
end
