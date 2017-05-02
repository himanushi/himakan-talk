class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from subscribed_channel(params[:url])
  end

  def talk(data)
    ActiveRecord::Base.transaction do
      # メッセージ作成
      message = Message.create!(
          user:      user = User.find_or_create_by!(name_and_password: data['user_name'].blank? ? '名無し' : data['user_name']),
          chat_room: ChatRoom.find_or_create_by!(url: data['url']) { |cr| cr.owned_by = user },
          content:   data['message'])

      # 不要なメッセージの削除
      count = Message.count
      if count > Settings.message.limit
        Message.order(id: :asc).limit(count - Settings.message.limit).map do |m|
          m.delete
        end
      end

      # クライアントに返却
      ActionCable.server.broadcast subscribed_channel(message.chat_room.url),
                                   { name: message.user.name,
                                     code: message.user.nickname_or_hash,
                                     message: message.content,
                                     date: message.created_at.strftime('%Y/%-m/%-d %H:%M') }
    end
  end

  private
    def subscribed_channel(url)
      "#{url}"
    end
end
