Rails.application.routes.draw do
  root to: 'rooms#check'
  get '/chat_rooms/:url', to: 'rooms#show'

  mount ActionCable.server => '/cable'
end
