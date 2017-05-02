class User < ApplicationRecord
  has_many :messages, dependent: :destroy
  before_create :create_name_and_hash

  def nickname_or_hash
    nickname || hash_code
  end

  def create_name_and_hash
    self.name =
      if name_and_password.index('@').nil?
        name_and_password
      elsif name_and_password.index('@') > 0
        name_and_password[0..(name_and_password.index('@')&.-1 || -1)]
      else
        ''
      end
    self.hash_code = Digest::SHA1.hexdigest(name_and_password)
  end
end