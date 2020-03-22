class Release < ApplicationRecord
  belongs_to :user
  belongs_to :repo

  has_many :commits

  validates :tag_name, presence: true

  def posting_data
    {
      "query": "state released",
      "issues": commits.pluck(:tickets).flatten.map{|ticket| { "id": ticket }},
      "comment": "Released in #{tag_name}"
    }.to_json
  end
end
