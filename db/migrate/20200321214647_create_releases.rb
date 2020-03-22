class CreateReleases < ActiveRecord::Migration[6.0]
  def change
    create_table :releases do |t|
      t.string :tag_name
      t.string :uid
      t.datetime :released_at
      t.references :user, null: false, foreign_key: true
      t.references :repo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
