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
        MnConvert.convert(mn_xml, sts_path, MnConvert::InputFormat::MN,
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
        MnConvert.convert(mn_xml, sts_path, MnConvert::InputFormat::MN,
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

  %w(adoc xml).each do |format|
    it "converts STS to MN #{format} in specified location" do
      Dir.mktmpdir do |dir|
        sts_path = -> (format) { File.join(dir, "sts.#{format}") }
        mn_path = -> (format) { File.join(dir, "mn.#{format}") }

        source = sts_path.('xml')
        mn_dest = mn_path.(format)
        FileUtils.cp(sts_xml, source)

        begin
          MnConvert.convert(source, mn_dest, MnConvert::InputFormat::STS,
            { output_format: format, debug: true })
        rescue RuntimeError => e
          puts e.message
          puts e.backtrace.inspect
          raise e
        end

        expect(File.exist?(mn_dest)).to be true
      end
    end
  end

  it "converts STS to MN adoc by default" do
    Dir.mktmpdir do |dir|
      sts_path = -> (format) { File.join(dir, "sts.#{format}") }

      source = sts_path.('xml')
      mn_adoc = sts_path.('adoc')
      FileUtils.cp(sts_xml, source)
      MnConvert.convert(source, mn_adoc, MnConvert::InputFormat::STS)

      expect(File.exist?(mn_adoc)).to be true
    end
  end

  it "splits bibdata and generates adoc output" do
    mn_path = -> (dir, format) { File.join(dir, "sts.#{format}") }
    Dir.mktmpdir do |dir|
      FileUtils.cp(sts_xml, mn_path.(dir, 'xml'))
      MnConvert.convert(mn_path.(dir, 'xml'), mn_path.(dir, 'adoc'),
        MnConvert::InputFormat::STS,
        { split_bibdata: true, debug: true })

      expect(File.exist?(mn_path.(dir, 'adoc'))).to be true
      expect(File.exist?(mn_path.(dir, 'rxl'))).to be true
    end
  end

  let(:sts_xml) do
    Pathname.new(File.dirname(__dir__)).
    join('spec', 'fixtures', 'rice-en.final.sts.xml').to_s
  end

  let(:mn_xml) do
    Pathname.new(File.dirname(__dir__))
      .join("spec", "fixtures", "rice-en.cd.mn.xml").to_s
  end
end
