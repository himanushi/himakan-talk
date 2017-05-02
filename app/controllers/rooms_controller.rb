class RoomsController < ApplicationController
  def check
    render json: { status: 200 }
  end

  def show
    messages = Message.joins(:chat_room)
                      .where(chat_rooms: {url: params[:url]})
                      .order(id: :asc)
                      .includes(:user).map do |message|
      { name: message.user.name,
        code: message.user.nickname_or_hash,
        message: message.content,
        date: message.created_at.strftime('%Y/%-m/%-d %H:%M') }
    end
    render json: messages
  end
end
