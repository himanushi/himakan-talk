class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room

  before_create :escape_blacklist

  def escape_blacklist
    self.content = Blacklist.parse(self.content)
  end

  def escape_content
    ERB::Util.html_escape(content)
  end
end
