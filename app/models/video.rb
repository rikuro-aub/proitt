# == Schema Information
#
# Table name: videos
#
#  id             :bigint           not null, primary key
#  video_id       :string           not null
#  tag_id         :bigint
#  description    :text
#  thumbnail_url  :text
#  view_count     :bigint
#  like_count     :integer
#  dislike_count  :integer
#  favorite_count :integer
#  active_flag    :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  title          :text
#

class Video < ApplicationRecord
end
