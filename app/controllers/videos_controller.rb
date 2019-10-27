class VideosController < ApplicationController
  skip_before_action :login_rquired

  def index
    display_items_by_tag = 4
    @videos = {}

    # トップページ表示用の動画を取得する
    @tags = Tag.all.order(:id)
    @tags.each do |tag|
      # いいね数/視聴回数 が上位の動画をトップページに表示する
      @videos.merge!(tag.tag.to_sym => Video.where(tag_id: tag).order('like_count/view_count DESC').limit(display_items_by_tag))
    end
  end

  def show
    @video = Video.find_by(id: params[:id])
  end
end
