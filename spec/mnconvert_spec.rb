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
    Dir.mktmpdir do |dir|
      sts_path = File.join(dir, "rice-en.cd.sts.xml")

      FileUtils.rm_f(sts_path)
      begin
        MnConvert.convert(mn_xml, sts_path, MnConvert::InputFormat::STS,
          { debug: true })
      rescue RuntimeError => e
        puts e.message
        puts e.backtrace.inspect
        raise e
      end
      expect(File.exist?(sts_path)).to be true
      expect(File.read(sts_path)).to include '<code language="ruby"'
    end
  end

  it "converts XML to ISO STS" do
    Dir.mktmpdir do |dir|
      sts_path = File.join(dir, "rice-en.cd.isosts.xml")

      FileUtils.rm_f(sts_path)
      begin
        MnConvert.convert(mn_xml, sts_path, MnConvert::InputFormat::STS,
          { output_format: :iso, debug: true })
      rescue RuntimeError => e
        puts e.message
        puts e.backtrace.inspect
        raise e
      end
      expect(File.exist?(sts_path)).to be true
      expect(File.read(sts_path)).to include '<preformat preformat-type="ruby">'
    end
  end

  it "converts XML to PDF" do
    Dir.mktmpdir do |dir|
      pdf_path = File.join(dir, "G.191.pdf")

      MnConvert.convert(sample_xml, pdf_path, MnConvert::InputFormat::MN,
        { xsl_file: sample_xsl, debug: true })
      expect(File.exist?(pdf_path)).to be true
    end
  end

  it "raise an error on converting not existing XML" do
    pdf_path = "missing.pdf"
    xml_path = "missing.xml"
    expect do
      MnConvert.convert(xml_path, pdf_path, MnConvert::InputFormat::MN,
        { xsl_file: sample_xsl, debug: true })
    end.to raise_error(/XML file '#{xml_path}' not found!/)
    expect(File.exist?(pdf_path)).to be false
  end

  let(:sample_xsl) do
    Pathname.new(File.dirname(__dir__))
      .join("spec", "fixtures", "itu.recommendation.xsl").to_s
  end

  let(:sample_xml) do
    Pathname.new(File.dirname(__dir__))
      .join("spec", "fixtures", "G.191.xml").to_s
  end

  let(:mn_xml) do
    Pathname.new(File.dirname(__dir__))
      .join("spec", "fixtures", "rice-en.cd.mn.xml").to_s
  end
end
