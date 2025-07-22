require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative "lib/mnconvert/version"

RSpec::Core::RakeTask.new(:spec)

task default: [
  "bin/mnconvert.jar",
  "spec/fixtures/rice-en.cd.mn.xml",
  "spec/fixtures/rice-en.final.sts.xml",
  "spec/fixtures/rfc8650.xml",
  :spec,
]

def uri_open(url)
  require 'open-uri'
  URI.parse(url).open
end

file "bin/mnconvert.jar" do |file|
  ver = MnConvert::MNCONVERT_JAR_VERSION
  url = "https://github.com/metanorma/mnconvert/releases/download/v#{ver}/mnconvert-#{ver}.jar"
  puts "Downloading... #{url}"
  File.open(file.name, "wb") do |f|
    f.write uri_open(url).read
  end
end

file "spec/fixtures/rice-en.cd.mn.xml" do |file|
  url = "https://raw.githubusercontent.com/metanorma/mn-samples-iso/gh-pages/documents/international-standard/rice-2023/document-en.cd.presentation.xml"
  puts "Downloading... #{url}"
  File.open(file.name, "w") do |saved_file|
    saved_file.write(uri_open(url).read)
  end
end

file "spec/fixtures/rice-en.final.sts.xml" do |file|
  url = "https://raw.githubusercontent.com/metanorma/sts2mn/master/src/test/resources/rice-en.final.sts.xml"
  puts "Downloading... #{url}"
  File.open(file.name, "w") do |saved_file|
    saved_file.write(uri_open(url).read)
  end
end

file "spec/fixtures/rfc8650.xml" do |file|
  url = "https://raw.githubusercontent.com/metanorma/mnconvert/main/src/test/resources/rfc/rfc8650.xml"
  puts "Downloading... #{url}"
  File.open(file.name, "w") do |saved_file|
    saved_file.write(uri_open(url).read)
  end
end
