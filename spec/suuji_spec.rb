require 'spec_helper'

describe Suuji do
  it 'has a version number' do
    expect(Suuji::VERSION).not_to be nil
  end

  describe '#to_kanji' do
    it 'converts decimal to Japanese numerals' do
      expect(Suuji.to_kanji(1)).to eq '一'
      expect(Suuji.to_kanji(10)).to eq '十'
      expect(Suuji.to_kanji(20)).to eq '二十'
      expect(Suuji.to_kanji(100)).to eq '百'
      expect(Suuji.to_kanji(400)).to eq '四百'
      expect(Suuji.to_kanji(404)).to eq '四百四'
      expect(Suuji.to_kanji(1111)).to eq '千百十一'
      expect(Suuji.to_kanji(7777)).to eq '七千七百七十七'
      expect(Suuji.to_kanji(8080)).to eq '八千八十'

      expect(Suuji.to_kanji(1_0000)).to eq '一万'
      expect(Suuji.to_kanji(100_0000)).to eq '百万'
      expect(Suuji.to_kanji(1000_0000)).to eq '千万'
      expect(Suuji.to_kanji(12_3456)).to eq '十二万三千四百五十六'
      expect(Suuji.to_kanji(1234_5678)).to eq '千二百三十四万五千六百七十八'

      expect(Suuji.to_kanji(1_0001_0001_0001_0000)).to eq '一京一兆一億一万'
      expect(Suuji.to_kanji(2345_2345_2345_2345_2345)).to eq '二千三百四十五京二千三百四十五兆二千三百四十五億二千三百四十五万二千三百四十五'
    end
  end

  # describe '#to_decimal' do
  #   it 'converts Japanese numerals to decimal' do
  #     expect(Suuji.to_decimal('一')).to eq 1
  #   end
  # end
end
