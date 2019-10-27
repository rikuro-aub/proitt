class TagsController < ApplicationController
    skip_before_action :login_rquired

    def index
        @tag = Tag.find_by(id: params[:format])
        @videos = Video.where(tag_id: params[:format]).page(params[:page])
    end
end
