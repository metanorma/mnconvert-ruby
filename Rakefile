require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require_relative 'lib/mnconvert/version'

RSpec::Core::RakeTask.new(:spec)

task :default => ['bin/mnconvert.jar', 'spec/fixtures/rice-en.cd.mn.xml', 'spec/fixtures/rice-en.final.sts.xml', :spec]

def uri_open(url)
  require 'open-uri'
  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.5")
    return open(url)
  end
  return URI.open(url)
end

file 'bin/mnconvert.jar' do |file|
  ver = MnConvert::MNCONVERT_JAR_VERSION
  url = "https://github.com/metanorma/mnconvert/releases/download/v#{ver}/mnconvert-#{ver}.jar"
  File.open(file.name, 'wb') do |file|
    file.write uri_open(url).read
  end
end

file 'spec/fixtures/rice-en.cd.mn.xml' do |file|
  uri = "https://raw.githubusercontent.com/metanorma/mn-samples-iso/gh-pages/documents/international-standard/rice-en.cd.xml"

  File.open(file.name, "w") do |saved_file|
    saved_file.write(uri_open(uri).read)
  end
end

file 'spec/fixtures/rice-en.final.sts.xml' do |file|
  uri = "https://raw.githubusercontent.com/metanorma/sts2mn/master/src/test/resources/rice-en.final.sts.xml"

  File.open(file.name, "w") do |saved_file|
    saved_file.write(uri_open(uri).read)
  end
end