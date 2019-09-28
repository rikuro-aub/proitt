class CreateVideosAndTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :tag, null: false
      t.boolean :active_flag

      t.timestamps
    end

    create_table :videos do |t|
      t.string :video_id, null: false
      t.belongs_to :tag
      t.text :description
      t.text :thumbnail_url, null: false
      t.bigint :view_count
      t.integer :like_count
      t.integer :dislike_count
      t.integer :favorite_count
      t.boolean :active_flag

      t.timestamps
    end
  end
end
