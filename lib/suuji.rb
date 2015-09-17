require "suuji/version"

module Suuji
  SUFFIXS = ['', '十', '百', '千'].freeze
  MYRIADS = ['', '万', '億', '兆', '京'].freeze

  def self.to_kanji(value)
    parts = value.to_s.reverse.scan(/.{1,4}/)

    result = ''
    parts.each_with_index do |part, index|
      result = "#{to_kanji_partial(part)}#{MYRIADS[index]}#{result}"
    end

    result
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

    def self.to_kanji_partial(value)
      digit_hash = Hash[arabic_numbers.zip(kanji_numbers)]

      result = ''
      0.upto(value.length - 1).each do |i|
        next unless value[i].to_i > 0

        number = (i > 0 && value[i] == '1') ? '' : digit_hash[value[i]]
        result = "#{number}#{SUFFIXS[i]}#{result}"
      end

      result
    end

    def self.to_arabic_partial(value)
      digit_hash = Hash[kanji_numbers.zip(arabic_numbers)]

      regex = ''
      SUFFIXS.each { |suffix| regex = "(?:(.?)#{suffix})?#{regex}" }
      digits = Regexp.new(regex).match(value)

      result = ''
      length = SUFFIXS.length
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

    def self.arabic_numbers
      %w(1 2 3 4 5 6 7 8 9)
    end

    def self.kanji_numbers
      %w(一 二 三 四 五 六 七 八 九)
    end
end
