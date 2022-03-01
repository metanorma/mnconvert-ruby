require "tmpdir"
require "fileutils"
require "pathname"

RSpec.describe MnConvert do
  it "gem version more or equal to JAR version" do
    gem_version = Gem::Version.new(MnConvert::VERSION)
    expect(gem_version).to be >= Gem::Version.new(MnConvert.version)
  end

  it "help not empty" do
    expect(MnConvert.help).not_to be_empty
  end

  it "converts XML to STS without specifying output" do
    input = copy_to_sandbox(mn_xml)
    output = Pathname.new(Dir.pwd) / "rice-en.cd.mn.sts.niso.xml"
    MnConvert.convert(
      input,
      {
        input_format: :metanorma,
        debug: true,
      },
    )
    expect(output.exist?).to be true
    expect(output.read).to match /<code id=".*" language="ruby"/
  end

  it "converts XML to STS" do
    sts_path = Pathname.new(Dir.pwd) / "rice-en.cd.sts.xml"
    MnConvert.convert(
      mn_xml,
      {
        output_file: sts_path,
        input_format: :metanorma,
        debug: true,
      },
    )
    expect(sts_path.exist?).to be true
    expect(sts_path.read).to match /<code id=".*" language="ruby"/
  end

  it "converts XML to STS (autodetect)" do
    out_path = Pathname.new(Dir.pwd) / "rice-en.xml"
    MnConvert.convert(mn_xml, { output_file: out_path })
    expect(out_path.exist?).to be true
    expect(out_path.read).to match /<code id=".*" language="ruby"/
  end

  it "converts XML to ISO STS" do
    sts_path = Pathname.new(Dir.pwd) / "rice-en.cd.isosts.xml"

    MnConvert.convert(
      mn_xml,
      {
        output_file: sts_path,
        input_format: :metanorma,
        output_format: :iso,
        debug: true,
      },
    )

    expect(sts_path.exist?).to be true
    expect(sts_path.read).to include '<preformat preformat-type="ruby">'
  end

  %w(adoc xml).each do |fmt|
    it "converts STS to MN #{fmt} in specified location" do
      source = copy_to_sandbox(sts_xml)
      output = source.sub_ext(".#{fmt}")
      MnConvert.convert(
        source,
        {
          output_file: output,
          input_format: :sts,
          output_format: fmt,
          debug: true,
        },
      )
      expect(output.exist?).to be true
    end
  end

  it "converts STS to MN adoc by default" do
    source = copy_to_sandbox(sts_xml)
    adoc = source.sub_ext(".adoc")
    MnConvert.convert(
      source,
      {
        output_file: adoc,
        input_format: MnConvert::InputFormat::STS,
        debug: true,
      },
    )
    expect(adoc.exist?).to be true
  end

  it "splits bibdata and generates adoc output" do
    input = copy_to_sandbox(sts_xml)
    adoc = input.sub_ext(".adoc")
    rxl = adoc.sub_ext(".rxl")
    MnConvert.convert(
      input,
      {
        output_file: adoc,
        input_format: MnConvert::InputFormat::STS,
        split_bibdata: true,
        debug: true,
      },
    )
    expect(adoc.exist?).to be true
    expect(rxl.exist?).to be true
  end

  it "converts RFC" do
    input = copy_to_sandbox(rfc_xml)
    MnConvert.convert(
      input,
      {
        input_format: :rfc,
        debug: true,
      },
    )
    output = input.sub_ext(".adoc")
    expect(output.exist?).to be true
    expect(output.read).to include "= Dynamic Subscription to YANG"
  end

  it "converts RFC (autoselect)" do
    output = Pathname.new(Dir.pwd) / "result.adoc"
    MnConvert.convert(rfc_xml, { output_file: output, debug: true })

    expect(output.exist?).to be true
    expect(output.read).to include "= Dynamic Subscription to YANG"
  end

  def copy_to_sandbox(file)
    result = Pathname.new(Dir.pwd) / File.basename(file)
    FileUtils.cp(file, result)
    result
  end

  let(:sts_xml) do
    Pathname.new(File.dirname(__dir__))
      .join("spec", "fixtures", "rice-en.final.sts.xml").to_s
  end

  let(:mn_xml) do
    Pathname.new(File.dirname(__dir__))
      .join("spec", "fixtures", "rice-en.cd.mn.xml").to_s
  end

  let(:rfc_xml) do
    Pathname.new(File.dirname(__dir__))
      .join("spec", "fixtures", "rfc8650.xml").to_s
  end
end
