class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room

  def escape_content
    ERB::Util.html_escape(content)
  end
end
