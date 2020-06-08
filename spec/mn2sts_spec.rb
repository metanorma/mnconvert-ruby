require 'tmpdir'

RSpec.describe Mn2sts do

  it 'matches the version number of JAR' do
    expect(Mn2sts::VERSION.split('.')[0..1].join('.')).to eq(Mn2sts.version)
    expect(Mn2sts::MN2STS_JAR_VERSION).to eq(Mn2sts.version)
  end

  it 'converts XML to STS' do

     Dir.mktmpdir do |dir|
       pdf_path = File.join(dir, 'test.mn.sts.xml')
       begin
       Mn2sts.convert(sample_xml, pdf_path)
       rescue RuntimeError => e  
         puts e.message
         puts e.backtrace.inspect
         raise e
       end
       expect(File.exist?(pdf_path)).to be true
     end

   end

   let(:sample_xml) do
     Pathname.new(File.dirname(__dir__)).
     join('spec', 'fixtures', 'test.mn.xml').to_s
   end

end
