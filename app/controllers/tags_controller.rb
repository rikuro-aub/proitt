class TagsController < ApplicationController
    def index
        @tag = Tag.find_by(id: params[:format])
        @videos = Video.where(tag_id: params[:format]).page(params[:page])
    end
end
