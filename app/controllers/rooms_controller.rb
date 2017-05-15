class RoomsController < ApplicationController
  def check
    render json: { status: 200 }
  end

  def connection_count
    render json: { count: ActionCable.server.connections.length }
  end

  def show
    messages = Message.joins(:chat_room)
                      .where(chat_rooms: {url: params[:url]})
                      .order(id: :asc)
                      .includes(:user).map do |message|
      { name: message.user.escape_name,
        code: message.user.nickname_or_hash,
        message: message.escape_content,
        date: message.created_at.strftime('%Y/%-m/%-d %H:%M') }
    end
    render json: messages
  end
end
