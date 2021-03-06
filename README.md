# Instabug Backend Challenge

I applied at [Instabug](https://instabug.com/) as a Software Engineer Backend. I Received this challenge as part of the recruitment process.
I was asked to develop endpoints(API) to Application Chatting System. In which the user can create Application and get back Application Token. Then use this Token to create chats and messages related to that Application. I have a little Ruby background knowledge, but i did my best to achieve technology best practices.

# Technologies
  * Ruby v(2.7.1)
  * Rails v(5.1.7)
  * Mysql v(8.0)
  * Redis v(4.6)
  * Elasticsearch v(7.13.3)
  * Sidekiq v(6.4.1)
  * Docker v(20.10.7)
# Installation and Run
Install docker and docker-compose before starting this installation process.

1. Clone the Repository
2. Open terminal and cd to the repository folder
3. Make sure that these ports are available. 
```Port:9200 (Elasticsearch)``` ```Port:6379 (Redis)``` ```Port:3306 (mysql)``` ```Port:3000 (API)```  
4. In terminal execute the following command ```docker-compose up```

# Database
### Description
There are three different: ```Apps```, ```Chats``` and ```Messages```. with 1-N relationship between Apps and Chats and 1-N relationship between Chats and Messages.

* Application
* Chat
* Message

Database Schema

![Screenshot 2022-04-23 171916](https://user-images.githubusercontent.com/36306083/164935885-37c5c0e0-2097-40fa-b4a4-dd81c51e184f.png)
# Indexes
* Created in chats table index on ```appToken``` and ```number``` in the same order. to be able to get chats by ```appToken``` and ```number``` faster or to get chats by ```appToken``` only. this index works for both.
* created in messages table index on ```chat_id``` and ```number``` in the same order. to be able to get messages by ```chat_id``` and ```number``` faster or to get messages by ```chat_id``` only. this index works for both
# API Routes
You could check this [postman collection](https://github.com/adhammamdouh/Instabug-Challenge/blob/main/Instabug%20Application%20Chat.postman_collection.json)
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
In this challenge there are multiple race conditions. one of them is the race condition that can occur while inserting new message or chat. since the chat number or message number are generated by the system, not the database. So we want to handle this condition if two requests want to add new messages or chats at the same time.

In this case, I used [Redis atomic Increment](https://redis.io/commands/incr/) function. this function provides me exactly what i want, Increment atomic function means that only one instance can access it at a time. 
# Elasticsearch
Elasticsearch is used to search over the messages partially. Elasticsearch Indexed on ```Chat_id``` not analyzed and ```content``` with English analyzer. 
```
query: { 
      bool: { 
        must: {
          query_string: {
            query: "*"+query.to_s+"*",
            fields: ['content'],
          }
        },
        filter: {
          term: {
            "chat_id" => chat_id
          }
        }
      }
```
This query is used to filter all the documents by ```chat_id``` and match the result with search term (query) provided by the user.
# Job Queuing
Here i used ```Sidekiq``` for two main purposes.
1. To provide asynchronous queue for inserting the messages and chats requests into the database.
2. Using ```Sidekiq Scheduler``` to schedule a two jobs. The first Job ```App Chat Counter``` to calculate the number of chats connected to each application. The second Job ```Chat Message Counter``` to calculate the number of messages connected to each chat. Both Jobs run every ```50 minutes```.

# How to run the test suite
Created Unit Tests for Application and Chats Controllers/Models Using RSpec.
**Caution:** test enviroment uses the same database the development enviroment uses. So be careful, becasue I added database cleaner before performing the test cases, and tests that would delete all the records in the database before performing the test cases.

You can run the test case by the following command:

```sudo docker-compose exec app bundle exec rspec```

You have to make sure that the docker images are running first before executing the test cases.
