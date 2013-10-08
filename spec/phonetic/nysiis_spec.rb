require './lib/phonetic/nysiis'
require './spec/phonetic/support/nysiis_data'

include Phonetic

describe NYSIIS do
  describe '.code' do
    it 'should return NYSIIS code of word' do
      NYSIIS_TEST_TABLE.each do |word, result|
        NYSIIS.code(word, trim: false).should == result
      end
    end

    it 'should return empty string for empty word' do
      NYSIIS.code('').should == ''
    end

    it 'should ignore non-english symbols in input' do
      NYSIIS.code('1234567890+-= Bess $').should == 'BAS'
    end
  end
end