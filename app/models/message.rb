require 'elasticsearch/model'

class Message < ApplicationRecord
  belongs_to :chat
  validates :content, :presence => true

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name Rails.application.class.parent_name.underscore
  document_type self.name.downcase

  settings index: { :number_of_shards => 1  } do

    mapping dynamic: false do
      indexes :chat_id, type: :integer, analyzer: 'not_analyzed'
      indexes :content, type: :string, analyzer: 'english'
    end
  end

  def as_indexed_json(options = nil)

    self.as_json( only: [ :chat_id, :content ] )
  end

  def self.search(chat_id, query)
    query = escape_elasticsearch_query(remove_blankspace_query(query))
    query_terms_count = query.split.length()

    __elasticsearch__.search(
    min_score: query_terms_count == 1 ? 1.0 : 2.0,
    query: { 
      bool: { 
        must: {
          query_string: {
            query: "*#{query}*",
            fields: ['content'],
          }
        },
        filter: {
          term: {
            "chat_id" => chat_id
          }
        }
      },
    }).records.to_json(except: [:id, :chat_id])
  end

  private
    def self.escape_elasticsearch_query(query)
      return query.gsub(/(\+|\-|\=|&&|\|\||\>|\<|\!|\(|\)|\{|\}|\[|\]|\^|"|~|\*|\?|\:|\\|\/)/, '\\\\\\1')
    end

    def self.remove_blankspace_query(query)
      return query.to_s.strip.gsub(/\s+/, " ")
    end

end

