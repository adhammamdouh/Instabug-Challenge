Rails.application.routes.draw do
  #resources :apps, default: :app_id do
  #  resources :chats do
  #    resources :messages
  #  end
  #end
  
  # Start Apps Routes

    get "/apps", to: "apps#index"
    post "/apps", to: "apps#create"
    get "/apps/:token", to: "apps#show"
    put "/apps/:token", to: "apps#update"
    # delete "/apps/:token", to: "apps#destroy"

  # End Apps Routes

  # Start Chat Routes

    get "/apps/:app_token/chats", to: "chats#index"
    post "/apps/:app_token/chats", to: "chats#create"
    get "/apps/:app_token/chats/:number", to: "chats#show"
    # put "/apps/:app_token/chats/:number", to: "chats#update"
    # delete "/apps/:app_token/chats/:number", to: "chats#destroy"

  # End Chat Routes

  # Start message Routes

    get "/apps/:app_token/chats/:chat_number/messages", to: "messages#index"
    post "/apps/:app_token/chats/:chat_number/messages", to: "messages#create"
    get "/apps/:app_token/chats/:chat_number/messages/:number", to: "messages#show"
    put "/apps/:app_token/chats/:chat_number/messages/:number", to: "messages#update"
    get "/apps/:app_token/chats/:chat_number/messages/search/:query", to: "messages#search"

    # delete "/apps/:app_token/chats/:chat_number/messages/:number", to: "messages#destroy"
  
  # End message Routes
end