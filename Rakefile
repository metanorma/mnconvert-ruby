require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require_relative 'lib/mnconvert/version'
require 'open-uri'

RSpec::Core::RakeTask.new(:spec)

task :default => ['bin/mnconvert.jar', 'spec/fixtures/rice-en.cd.mn.xml', :spec]

require 'open-uri'

file 'bin/mnconvert.jar' do |file|
  ver = MnConvert::MNCONVERT_JAR_VERSION
  url = "https://github.com/metanorma/mnconvert/releases/download/v#{ver}/mnconvert-#{ver}.jar"
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
