require "uri"

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room

  before_create :escape_blacklist

  def escape_blacklist
    self.content = Blacklist.parse(self.content)
  end

  def escape_content
    text = ERB::Util.html_escape(content)

    URI.extract(text, ['http','https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"

      text.gsub!(url, sub_text)
    end

    text
  end
end
