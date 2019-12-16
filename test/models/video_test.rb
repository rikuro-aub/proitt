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
#  japanese_flag  :boolean
#

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
