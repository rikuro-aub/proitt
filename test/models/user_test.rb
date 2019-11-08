# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  name         :string
#  image_url    :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  token_digest :string           not null
#  user_id      :string           not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
