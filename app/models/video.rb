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
    belongs_to :tag
    has_many :comments
    has_many :favorites
    has_many :users, through: :comments
    has_many :users, through: :favorites

    def favorite?(user_id)
        self.favorites.find_by(user_id: user_id)
    end

    def favorites_count
        self.favorites.count
    end
end
