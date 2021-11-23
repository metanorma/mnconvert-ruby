require "tmpdir"
require "fileutils"

RSpec.describe MnConvert do
  it "gem version more or equal to JAR version" do
    gem_version = Gem::Version.new(MnConvert::VERSION)
    expect(gem_version).to be >= Gem::Version.new(MnConvert.version)
  end

  it "help not empty" do
    expect(MnConvert.help).not_to be_empty
  end

  it "converts XML to STS" do
    sts_path = File.join(Dir.pwd, "rice-en.cd.sts.xml")
    FileUtils.rm_f(sts_path)
    MnConvert.convert(
      mn_xml, sts_path,
      { input_format: :metanorma, debug: true }
    )
    expect(File.exist?(sts_path)).to be true
    expect(File.read(sts_path)).to include '<code language="ruby"'
  end

  it "converts XML to STS (autodetect)" do
    out_path = File.join(Dir.pwd, "rice-en.xml")
    MnConvert.convert(mn_xml, out_path)
    expect(File.exist?(out_path)).to be true
    expect(File.read(out_path)).to include '<code language="ruby"'
  end

  it "converts XML to ISO STS" do
    sts_path = File.join(Dir.pwd, "rice-en.cd.isosts.xml")

    FileUtils.rm_f(sts_path)
    MnConvert.convert(
      mn_xml, sts_path,
      { input_format: :metanorma, output_format: :iso, debug: true }
    )

    expect(File.exist?(sts_path)).to be true
    expect(File.read(sts_path)).to include '<preformat preformat-type="ruby">'
  end

  %w(adoc xml).each do |format|
    it "converts STS to MN #{format} in specified location" do
      sts_path = ->(fmt) { File.join(Dir.pwd, "sts.#{fmt}") }
      mn_path = ->(fmt) { File.join(Dir.pwd, "mn.#{fmt}") }

      source = sts_path.("xml")
      mn_dest = mn_path.(format)
      FileUtils.cp(sts_xml, source)

      MnConvert.convert(
        source, mn_dest,
        { input_format: :sts,
          output_format: format,
          debug: true }
      )

      expect(File.exist?(mn_dest)).to be true
    end
  end

  it "converts STS to MN adoc by default" do
    sts_path = ->(fmt) { File.join(Dir.pwd, "sts.#{fmt}") }

    source = sts_path.("xml")
    mn_adoc = sts_path.("adoc")
    FileUtils.cp(sts_xml, source)
    MnConvert.convert(
      source, mn_adoc,
      { input_format: MnConvert::InputFormat::STS }
    )

    expect(File.exist?(mn_adoc)).to be true
  end

  it "splits bibdata and generates adoc output" do
    mn_path = ->(fmt) { File.join(Dir.pwd, "sts.#{fmt}") }
    FileUtils.cp(sts_xml, mn_path.("xml"))
    MnConvert.convert(
      mn_path.("xml"),
      mn_path.("adoc"),
      { input_format: MnConvert::InputFormat::STS,
        split_bibdata: true,
        debug: true },
    )

    expect(File.exist?(mn_path.("adoc"))).to be true
    expect(File.exist?(mn_path.("rxl"))).to be true
  end

  let(:sts_xml) do
    Pathname.new(File.dirname(__dir__))
      .join("spec", "fixtures", "rice-en.final.sts.xml").to_s
  end

  let(:mn_xml) do
    Pathname.new(File.dirname(__dir__))
      .join("spec", "fixtures", "rice-en.cd.mn.xml").to_s
  end
end
