require 'elasticsearch/model'

class Message < ApplicationRecord
  belongs_to :chat
  validates :content, :presence => true

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

#   index_name 'Instabug_challenge'
#   document_type 'message'

  
  settings index: { :number_of_shards => 1  } do

    mapping dynamic: false do
      indexes :chat_id, type: :integer, analyzer: 'not_analyzed'
      indexes :content, type: :string, analyzer: 'english'
    end
  end

  def as_indexed_json(options = nil)

    self.as_json( only: [ :content, :number, :created_at, :updated_at ] )
  end

  def self.search(chat_id, query)
    @messages = []
    @docs = __elasticsearch__.search({
        query: {
          constant_score: {
            filter: {
              term: {
                chat_id: chat_id
              }
            }
          }
        },
        query: {
          regexp: {
            content: ".*" + query + ".*"
          }
          # wildcard: {
          #   content: '*' + query + '*'
          # }
        },
      })

    @docs.each { |doc|
      @messages << doc[:_source]
    }
    return @messages
  end

  # filter: {

  #   terms: {
  #     chat_id: chat_id
  #   }
  
  # }

end

Message.__elasticsearch__.create_index!
Message.import
