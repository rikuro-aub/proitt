# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string
#  image_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
    has_many :commnet
    has_many :favorite
    has_many :video, through: :comment
    has_many :video, through: :favorite
end
