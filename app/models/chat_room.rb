class ChatRoom < ApplicationRecord
  has_many :messages
  belongs_to :owned_by, class_name: User, foreign_key: :owner_id
end
