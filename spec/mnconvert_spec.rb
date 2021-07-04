require "tmpdir"
require "fileutils"

RSpec.describe MnConvert do
  it "matches the version number of JAR" do
    expect(MnConvert::VERSION.split(".")[0..1].join(".")).to eq(MnConvert.version)
    expect(MnConvert::MNCONVERT_JAR_VERSION).to eq(MnConvert.version)
  end

  it "help not empty" do
    expect(MnConvert.help).not_to be_empty
  end

  it "converts XML to STS" do
    Dir.mktmpdir do |dir|
      sts_path = File.join(dir, "rice-en.cd.sts.xml")

      FileUtils.rm_f(sts_path)
      begin
        MnConvert.convert(mn_xml, sts_path)
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
        MnConvert.convert(mn_xml, sts_path, iso: true)
      rescue RuntimeError => e
        puts e.message
        puts e.backtrace.inspect
        raise e
      end
      expect(File.exist?(sts_path)).to be true
      expect(File.read(sts_path)).to include '<preformat preformat-type="ruby">'
    end
  end

  let(:mn_xml) do
    Pathname.new(File.dirname(__dir__))
      .join("spec", "fixtures", "rice-en.cd.mn.xml").to_s
  end
end
