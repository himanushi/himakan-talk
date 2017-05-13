Rails.application.routes.draw do
  root to: 'rooms#check'
  get '/chat_rooms/connection_count', to: 'rooms#connection_count'
  get '/chat_rooms/:url', to: 'rooms#show'

  mount ActionCable.server => '/cable'
end
