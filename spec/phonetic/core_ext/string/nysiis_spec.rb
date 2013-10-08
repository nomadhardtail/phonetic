require './lib/phonetic/core_ext/string/nysiis'
require './spec/phonetic/support/nysiis_data'

describe String do
  describe '#nysiis' do
    it 'should return NYSIIS code of word' do
      NYSIIS_TEST_TABLE.each do |word, result|
        word.nysiis(trim: false).should == result
      end
    end

    it 'should return empty string for empty word' do
      ''.nysiis.should == ''
    end

    it 'should ignore non-english symbols in input' do
      '1234567890+-= Bess $'.nysiis.should == 'BAS'
    end
  end
end 