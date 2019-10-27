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

class User < ApplicationRecord
    has_many :commnet
    has_many :favorite
    has_many :video, through: :comment
    has_many :video, through: :favorite

    def self.create_with_omniauth(auth)
        create! do |user|
          user.user_id = auth['uid']
          user.name = auth['info']['nickname']
          user.token_digest = Digest::SHA256.hexdigest auth['credentials']['token']
        end
    end
end
