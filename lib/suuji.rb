require "suuji/version"

module Suuji
  ARABIC_NUMBERS = %w(1 2 3 4 5 6 7 8 9).freeze
  KANJI_NUMBERS = %w(一 二 三 四 五 六 七 八 九).freeze
  DAIJI_NUMBERS = %w(壱 弐 参 四 五 六 七 八 九).freeze
  KANJI_SUFFIXS = ['', '十', '百', '千'].freeze
  DAIJI_SUFFIXS = ['', '拾', '百', '千'].freeze
  MYRIADS = ['', '万', '億', '兆', '京'].freeze

  def self.to_kanji(number, use_daiji = false)
    parts = number.to_s.reverse.scan(/.{1,4}/)

    parts.each_with_index.inject([]) do |arr, (part, index)|
      arr << "#{to_kanji_partial(part, use_daiji)}#{MYRIADS[index]}"
    end.reverse.join('')
  end

  def self.to_daiji(number)
    to_kanji(number, true)
  end

  def self.to_arabic(number)
    pattern = MYRIADS.inject([]) do |arr, myriad|
      arr << "(?:(.*)#{myriad})?"
    end.reverse.join('')

    parts = Regexp.new(pattern).match(number)

    (1..MYRIADS.length).inject([]) do |arr, i|
      arr << to_arabic_partial(parts[i]) unless parts[i].nil?
      arr
    end.join('').to_i
  end

  private

    def self.to_kanji_partial(number, use_daiji)
      suffixs = (use_daiji ? DAIJI_SUFFIXS : KANJI_SUFFIXS)
      japanese_numbers = use_daiji ? DAIJI_NUMBERS : KANJI_NUMBERS
      digit_hash = ARABIC_NUMBERS.zip(japanese_numbers).to_h

      number.split('').each_with_index.inject([]) do |arr, (digit, index)|
        if digit.to_i.positive?
          num = (index > 0 && digit == '1') ? nil : digit_hash[digit]
          arr << "#{num}#{suffixs[index]}"
        end

        arr
      end.reverse.join('')
    end

    def self.to_arabic_partial(number)
      use_daiji = is_daiji? number
      suffixs = (use_daiji ? DAIJI_SUFFIXS : KANJI_SUFFIXS)
      japanese_numbers = (use_daiji ? DAIJI_NUMBERS : KANJI_NUMBERS)
      digit_hash = japanese_numbers.zip(ARABIC_NUMBERS).to_h

      pattern = suffixs.inject([]) do |arr, suffix|
        arr << "(?:(.?)#{suffix})?"
      end.reverse.join('')

      digits = Regexp.new(pattern).match(number)

      length = suffixs.length
      (1..length).inject([]) do |arr, i|
        case digits[i]
        when nil  then arr << '0'
        when ''   then arr << (i == length ? '0' : '1')
        else arr << digit_hash[digits[i]]
        end
      end.join('')
    end

    def self.is_daiji?(value)
      value =~ /[壱弐参拾]/
    end
end
