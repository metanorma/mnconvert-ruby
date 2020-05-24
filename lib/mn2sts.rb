require 'open3'
require 'mn2sts/version'

module Mn2sts
  MN2STS_JAR_PATH = File.join(File.dirname(__FILE__), '../bin/mn2sts.jar')

  def self.help
    cmd = ['java', '-jar', MN2STS_JAR_PATH].join(' ')
    message, error_str, status = Open3.capture3(cmd)
    message
  end

  def self.version
    cmd = ['java', '-jar', MN2STS_JAR_PATH, '-v'].join(' ')
    message, error_str, status = Open3.capture3(cmd)
    message.strip
  end

  def self.convert(url_path, output_path, xsl_stylesheet)
    return if url_path.nil? || output_path.nil? || xsl_stylesheet.nil?

    puts MN2STS_JAR_PATH
    cmd = ['java', '-Xss5m', '-Xmx1024m', '-jar', MN2STS_JAR_PATH, '--xml-file',
           url_path, '--xsl-file', xsl_stylesheet, '--pdf-file',
           output_path].join(' ')

    puts cmd
    _, error_str, status = Open3.capture3(cmd)

    unless status.success?
      raise error_str
    end
  end

end
