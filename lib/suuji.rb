require "suuji/version"

module Suuji
  ARABIC_NUMBERS = %w(1 2 3 4 5 6 7 8 9).freeze
  KANJI_NUMBERS = %w(一 二 三 四 五 六 七 八 九).freeze
  DAIJI_NUMBERS = %w(壱 弐 参 四 五 六 七 八 九).freeze
  KANJI_SUFFIXS = ['', '十', '百', '千'].freeze
  DAIJI_SUFFIXS = ['', '拾', '百', '千'].freeze
  MYRIADS = ['', '万', '億', '兆', '京'].freeze

  def self.to_kanji(value, use_daiji = false)
    parts = value.to_s.reverse.scan(/.{1,4}/)

    result = ''
    parts.each_with_index do |part, index|
      result = "#{to_kanji_partial(part, use_daiji)}#{MYRIADS[index]}#{result}"
    end

    result
  end

  def self.to_daiji(value)
    to_kanji(value, true)
  end

  def self.to_arabic(value)
    regex = ''
    MYRIADS.each { |myriad| regex = "(?:(.*)#{myriad})?#{regex}" }

    parts = Regexp.new(regex).match(value)

    result = ''
    (1..MYRIADS.length).each do |i|
      result += to_arabic_partial(parts[i]) unless parts[i].nil?
    end

    result.to_i
  end

  private

    def self.to_kanji_partial(value, use_daiji)
      japanese_numbers = (use_daiji ? DAIJI_NUMBERS : KANJI_NUMBERS)
      digit_hash = Hash[ARABIC_NUMBERS.zip(japanese_numbers)]
      suffixs = (use_daiji ? DAIJI_SUFFIXS : KANJI_SUFFIXS)

      result = ''
      0.upto(value.length - 1).each do |i|
        next unless value[i].to_i > 0

        number = (i > 0 && value[i] == '1') ? '' : digit_hash[value[i]]
        result = "#{number}#{suffixs[i]}#{result}"
      end

      result
    end

    def self.to_arabic_partial(value)
      use_daiji = is_daiji? value
      japanese_numbers = (use_daiji ? DAIJI_NUMBERS : KANJI_NUMBERS)
      digit_hash = Hash[japanese_numbers.zip(ARABIC_NUMBERS)]
      suffixs = (use_daiji ? DAIJI_SUFFIXS : KANJI_SUFFIXS)

      regex = ''
      suffixs.each { |suffix| regex = "(?:(.?)#{suffix})?#{regex}" }
      digits = Regexp.new(regex).match(value)

      result = ''
      length = suffixs.length
      (1..length).each do |i|
        case digits[i]
        when nil
          result += '0'
        when ''
          result += (i == length) ? '0' : '1'
        else
          result += digit_hash[digits[i]]
        end
      end

      result
    end

    def self.is_daiji?(value)
      value =~ /[壱弐参拾]/
    end
end
