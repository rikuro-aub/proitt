class AddJapaneseFlagToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :japanese_flag, :boolean
  end
end
