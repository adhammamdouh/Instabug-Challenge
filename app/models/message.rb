require 'elasticsearch/model'

class Message < ApplicationRecord
  belongs_to :chat
  validates :content, :presence => true

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

#   index_name 'Instabug_challenge'
#   document_type 'message'

  
#   #{ number_of_shards: 1 }
  settings index: { :number_of_shards => 1  } do

    mapping dynamic: false do
      indexes :chat_id, type: :integer, analyzer: 'not_analyzed'
      indexes :content, type: :string, analyzer: 'english'
    end
  end

  #Message.import(force: true)

  def as_indexed_json(options = nil)

    self.as_json( only: [ :chat_id, :content, :number, :created_at, :updated_at ] )
  end

  def self.search(chat_id, query)
    __elasticsearch__.search(

      {
   
        query: {
          constant_score: {
            filter: {
              term: {
                chat_id: chat_id
              }
            }
          }
          
   
        },
   
         # more blocks will go IN HERE. Keep reading!
   
      }
    )
  end

  # multi_match: {
  #   query: query,
  #   fields: ['content']
  # }

end

Message.__elasticsearch__.create_index!
Message.import
