# Instabug Backend Challenge

I was asked to develop endpoints(API) to Application Chatting System. In which the user can create Application and get back Application Token. Then use this Token to create chats and messages related to this Application. I have a little Ruby background knowledge, but i did my best to achive techonolgies best practices.

# Technologies
  * Ruby v(2.7.1)
  * Rails v(5.1.7)
  * Mysql v(8.0)
  * Redis v(4.6)
  * Elasticsearch v(7.13.3)
  * Sidekiq v(6.4.1)
  * Docker v(20.10.7)
# Installation and Run
install docker and docker-compose berfore the installation process.

1. Clone the repo
2. Open terminal and cd to the repository folder
3. In terminal execute the following com ```docker-compose up```

# Database
### Description
There are three different: ```Apps```, ```Chats``` and ```Messages```. with 1-N relationship between Apps and Chats and 1-N relationship between Chats and Messages.

* Application
* Chat
* Message

Database Schema
Insert pic here
# Indexes
* Created in chats table index on appToken and number in the same order. to be able to get chats by appToken and number faster or to get chats by appToken only. this index works for both.
* created in messages table index on chat_id and number in the same order. to be able to get messages by chat_id and number faster or to get messages by chat_id only. this index works for both
# API Routes
## App
#### GET All Apps
    GEt: /apps
#### CREATE App
    POST: /apps
#### GET App By Token
    GET /apps/:token
#### UPDATE App By Token
    PUT /apps/:token
## Chat
#### GET All Chats
    GET /apps/:app_token/chats
#### CREATE Chat
    POST: /apps/:app_token/chats
#### GET Chat By Number
    GET: /apps/:app_token/chats/:number
## Messages
#### GET All Messages
    GET: /apps/:app_token/chats/:chat_number/messages
#### CREATE Message
    POST: /apps/:app_token/chats/:chat_number/messages
#### SEARCH Messages By Query
    POST: /apps/:app_token/chats/:chat_number/messages/search
#### GET Chat By Number
    GET: /apps/:app_token/chats/:chat_number/messages/:number
#### UPDATE Chat
    PUT: /apps/:app_token/chats/:chat_number/messages/:number
# Racing Condition
In this challenge there are multiple race conditions. one of them is the race condition that could happen while inserting new message or chat. since the chat number or message number are generated by the system not the database. So we want to handle this condition if two requests want to add new messages or chats at the same time.

In this case, I used ```Redis Incr``` function. this function provides me what i want this function is atomic. therefore only one instance can access it at a time. 
# Redis
# Elasticsearch
# Job Queuing
# Postman Collection
# How to run the test suite
