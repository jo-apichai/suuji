require "suuji/version"

module Suuji
  DIGITS = {
    '1' => '一',
    '2' => '二',
    '3' => '三',
    '4' => '四',
    '5' => '五',
    '6' => '六',
    '7' => '七',
    '8' => '八',
    '9' => '九'
  }.freeze

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

  # def self.to_decimal(value)
  #   digits = DIGITS.invert
  #   digits[value].to_i
  # end

  private

  def self.to_kanji_partial(value)
    result = ''

    0.upto(value.length - 1).each do |i|
      next unless value[i].to_i > 0

      num = (i > 0 && value[i] == '1') ? '' : DIGITS[value[i]]
      result = "#{num}#{SUFFIXS[i]}#{result}"
    end

    result
  end
end
