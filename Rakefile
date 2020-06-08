require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require_relative 'lib/mn2sts/version'
require 'open-uri'

RSpec::Core::RakeTask.new(:spec)

task :default => ['bin/mn2sts.jar', 'spec/fixtures/rice-en.cd.mn.xml', :spec]

require 'open-uri'

file 'bin/mn2sts.jar' do |file|
  ver = Mn2sts::MN2STS_JAR_VERSION
  url = "https://github.com/metanorma/mn2sts/releases/download/v#{ver}/mn2sts-#{ver}.jar"
  File.open(file.name, 'wb') do |file|
    file.write open(url).read
  end
end

file 'spec/fixtures/rice-en.cd.mn.xml' do |file|
  uri = "https://raw.githubusercontent.com/metanorma/mn-samples-iso/gh-pages/documents/international-standard/rice-en.cd.xml"

  File.open(file.name, "w") do |saved_file|
    # the following "open" is provided by open-uri
    open(uri, "r") do |read_file|
      saved_file.write(read_file.read)
    end
  end

end
