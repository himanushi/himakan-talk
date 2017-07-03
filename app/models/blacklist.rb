require 'nkf'

class Blacklist < ApplicationRecord
  class << self
    def parse(message)
      message = NKF.nkf('-Xw',message)
      self.all.each do |black|
        message.gsub!(/#{black.word}/, '*' * black.word.size)
      end
      message
    end
  end
end
