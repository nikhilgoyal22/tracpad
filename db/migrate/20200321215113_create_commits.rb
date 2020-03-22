class CreateCommits < ActiveRecord::Migration[6.0]
  def change
    create_table :commits do |t|
      t.string :commit_type
      t.text :sha
      t.text :description
      t.datetime :committed_at
      t.text :tickets, array: true, default: []
      t.references :release, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :repo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
