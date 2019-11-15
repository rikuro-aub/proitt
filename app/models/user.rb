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
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :videos, through: :comments
    has_many :videos, through: :favorites

    def self.create_with_omniauth(auth)
        create! do |user|
          user.name = auth['info']['nickname']
          user.image_url = auth['extra']['raw_info']['avatar_url']
          user.token_digest = Digest::SHA256.hexdigest auth['credentials']['token']
          user.user_id = auth['uid']
        end
    end

    def equal_token?(token)
        return false if token.nil?
        self.token_digest == (Digest::SHA256.hexdigest token) ? true : false
    end
end
