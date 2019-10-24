# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  comment    :text
#  user_id    :bigint
#  video_id   :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
