class CreateUsersAndCommentsAndFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :image_url

      t.timestamps
    end

    create_table :comments do |t|
      t.text :comment
      t.belongs_to :user
      t.belongs_to :video

      t.timestamps
    end

    create_table :favorites do |t|
      t.belongs_to :user
      t.belongs_to :video

      t.timestamps
    end
  end
end
