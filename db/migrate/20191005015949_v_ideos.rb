class VIdeos < ActiveRecord::Migration[5.2]
  def change
    change_column_null :videos, :thumbnail_url, true
    add_column :videos, :title, :text
  end
end
