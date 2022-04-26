Rails.application.routes.draw do
  # Start Apps Routes

    get "/apps", to: "apps#index"
    post "/apps", to: "apps#create"
    get "/apps/:token", to: "apps#show"
    put "/apps/:token", to: "apps#update"

  # End Apps Routes

  # Start Chat Routes

    get "/apps/:app_token/chats", to: "chats#index"
    post "/apps/:app_token/chats", to: "chats#create"
    get "/apps/:app_token/chats/:number", to: "chats#show"

  # End Chat Routes

  # Start message Routes

    get "/apps/:app_token/chats/:chat_number/messages", to: "messages#index"
    post "/apps/:app_token/chats/:chat_number/messages", to: "messages#create"
    post "/apps/:app_token/chats/:chat_number/messages/search", to: "messages#search"
    get "/apps/:app_token/chats/:chat_number/messages/:number", to: "messages#show"
    put "/apps/:app_token/chats/:chat_number/messages/:number", to: "messages#update"
  
  # End message Routes
end