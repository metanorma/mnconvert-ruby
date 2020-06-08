require 'tmpdir'

RSpec.describe Mn2sts do

  it 'matches the version number of JAR' do
    expect(Mn2sts::VERSION.split('.')[0..1].join('.')).to eq(Mn2sts.version)
    expect(Mn2sts::MN2STS_JAR_VERSION).to eq(Mn2sts.version)
  end

  it 'converts XML to STS' do

    Dir.mktmpdir do |dir|
      sts_path = File.join(dir, 'rice-en.cd.sts.xml')

      begin
        Mn2sts.convert(mn_xml, sts_path)
      rescue RuntimeError => e
        puts e.message
        puts e.backtrace.inspect
        raise e
      end

      expect(File.exist?(sts_path)).to be true
    end

  end

  let(:mn_xml) do
    Pathname.new(File.dirname(__dir__)).
    join('spec', 'fixtures', 'rice-en.cd.mn.xml').to_s
  end

end
