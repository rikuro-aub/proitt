class TagsController < ApplicationController
    skip_before_action :login_rquired

    def index
        @tag = Tag.find_by(id: params[:format])

        # 日本語動画を優先して表示する
        # いいね数/視聴回数 が上位の動画を優先して表示する
        @videos = Video.where(tag_id: params[:format]).order('japanese_flag DESC, like_count/view_count DESC').page(params[:page])
    end
end
