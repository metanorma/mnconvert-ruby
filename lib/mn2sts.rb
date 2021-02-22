require "open3"
require "mn2sts/version"

module Mn2sts
  MN2STS_JAR_PATH = File.join(File.dirname(__FILE__), "../bin/mn2sts.jar")

  def self.jvm_options
    options = []

    if RbConfig::CONFIG["host_os"].match?(/darwin|mac os/)
      options << "-Dapple.awt.UIElement=true"
    end

    options
  end

  def self.help
    cmd = ["java", *jvm_options, "-jar", MN2STS_JAR_PATH].join(" ")
    message, = Open3.capture3(cmd)
    message
  end

  def self.version
    cmd = ["java", *jvm_options, "-jar", MN2STS_JAR_PATH, "-v"].join(" ")
    message, = Open3.capture3(cmd)
    message.strip
  end

  def self.convert(xml_path_in, xml_path_out, opts = {})
    return if xml_path_in.nil? || xml_path_out.nil?

    cmd = ["java", "-Xss5m", "-Xmx1024m", *jvm_options, "-jar", MN2STS_JAR_PATH,
           "--xml-file-in", xml_path_in, "--xml-file-out", xml_path_out].join(" ")

    cmd += " --output-format iso" if opts[:iso]

    puts cmd
    _, error_str, status = Open3.capture3(cmd)

    unless status.success?
      warn error_str
      raise error_str
    end
  end
end
