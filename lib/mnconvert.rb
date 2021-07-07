require "open3"
require "mnconvert/version"

module MnConvert
  module InputFormat
    MN = :metanorma
    STS = :sts
  end

  MNCONVERT_JAR_PATH = File.join(File.dirname(__FILE__), "../bin/mnconvert.jar")

  def self.jvm_options
    options = ["-Xss5m", "-Xmx1024m"]

    if RbConfig::CONFIG["host_os"].match?(/darwin|mac os/)
      options << "-Dapple.awt.UIElement=true"
    end

    options
  end

  def self.help
    cmd = ["java", *jvm_options, "-jar", MNCONVERT_JAR_PATH].join(" ")
    message, = Open3.capture3(cmd)
    message
  end

  def self.version
    cmd = ["java", *jvm_options, "-jar", MNCONVERT_JAR_PATH, "-v"].join(" ")
    message, = Open3.capture3(cmd)
    message.strip
  end

  def self.convert(input_file, output_file, input_format, opts = {})
    validate(opts, input_format)

    cmd = ["java", *jvm_options, "-jar", MNCONVERT_JAR_PATH,
           input_file, "--input-format", input_format,
           "--output", output_file, *optional_opts(opts)].join(" ")

    puts cmd if opts[:debug]
    output_str, error_str, status = Open3.capture3(cmd)
    p output_str if opts[:debug]

    unless status.success?
      raise error_str
    end
  end

  class << self
    private

    def validate(opts, input_format)
      output_format = opts[:output_format]

      case input_format
      when InputFormat::MN
        validate_mn(opts, output_format)
      when InputFormat::STS
        validate_sts(opts, output_format)
      else
        raise StandardError.new("Invalid input format: #{input_format}")
      end
    end

    def validate_mn(opts, output_format)
      unless output_format.nil? || %W(iso niso).include?(output_format.to_s)
        raise StandardError.new("Invalid output format: #{output_format}")
      end

      if opts[:split_bibdata]
        raise StandardError.new("split_bibdata valid only for sts input")
      end

      if opts[:sts_type]
        raise StandardError.new("sts_type valid only for sts input")
      end
    end

    def validate_sts(_opts, output_format)
      unless output_format.nil? || %w(xml adoc).include?(output_format.to_s)
        raise StandardError.new("Invalid output format: #{output_format}")
      end
    end

    def optional_opts(opts)
      result = []

      {
        sts_type: "--type", imagesdir: "--imagesdir", check_type: "--check-type",
        output_format: "--output-format", xsl_file: "--xsl-file",
      }.reject { |k, _| opts[k].nil? }.map { |k, v| "#{v} #{opts[k]}" }

      result << "--debug" if opts[:debug]
      result << "--split-bibdata" if opts[:split_bibdata]
      result
    end
  end
end
