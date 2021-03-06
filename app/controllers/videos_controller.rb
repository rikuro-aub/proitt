class VideosController < ApplicationController
  skip_before_action :login_rquired

  def index
    display_items_by_tag = 4
    @videos = {}

    # トップページ表示用の動画を取得する
    @tags = Tag.all.order(:id)
    @tags_paginate = Tag.where(active_flag: true).order(:id).page(params[:page])
    @tags_paginate.each do |tag|
      # 日本語動画を優先してトップページに表示する
      # いいね数/視聴回数 が上位の動画を優先してトップページに表示する
      @videos.merge!(tag.tag.to_sym => Video.where(tag_id: tag).order('japanese_flag DESC, like_count/view_count DESC').limit(display_items_by_tag))
    end
  end

  def show
    @video = Video.find(params[:id])
    @favorite = @video.favorites.where(user_id: session[:user_id])
  end

  def search
    @q = Video.search(search_params)
    @search_videos = @q.result(distinct: true).page(params[:page])
  end

  private
    def search_params
      params.require(:q).permit(:title_or_description_cont)
    end
end
