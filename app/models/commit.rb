class Commit < ApplicationRecord
  belongs_to :release, optional: true
  belongs_to :user
  belongs_to :repo

  validates :sha, presence: true
  validates :commit_type, inclusion: { in: %w(FEAT CHORE FIX) }

  def posting_data
    {
      "query": "state ready for release",
      "issues": tickets.map{|ticket| { "id": ticket }},
      "comment": "See SHA ##{sha}"
    }.to_json
  end
end
