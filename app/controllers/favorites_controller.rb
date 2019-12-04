class FavoritesController < ApplicationController
    def create
        video = Video.find(params[:video_id])

        # 正当なユーザーであることを確認
        unless User.find(session[:user_id]).equal_token?(session[:token])
            flash[:error] = '失敗しました / 再ログイン後にお気にいり操作を再実行してください'
            redirect_to video_path(video) and return
        end

        video.favorites.create(user_id: session[:user_id])
        favorite = video.favorites.where(user_id: session[:user_id])

        render partial: 'destroy.js.erb', locals: {video: video, favorite: favorite}
    end


    def destroy
        video = Video.find(params[:video_id])

        # 正当なユーザーであることを確認
        unless User.find(session[:user_id]).equal_token?(session[:token])
            flash[:error] = '失敗しました / 再ログイン後にお気にいり操作を再実行してください'
            redirect_to video_path(video) and return
        end

        video.favorites.find_by(user_id: session[:user_id]).destroy
        favorite = video.favorites.where(user_id: session[:user_id])

        render partial: 'create.js.erb', locals: {video: video, favorite: favorite}
    end

    def index
        @user = User.find(params[:user_id])

        # 正当なユーザーであることを確認
        unless @user.equal_token?(session[:token])
          flash[:error] = 'マイページへのアクセスに失敗しました / 再ログイン後にやり直してください'
          redirect_to root_path and return
        end

        favorite_videos = Favorite.where(user_id: @user.id).includes(:video).map(&:video)
        @paginatable_favorite_videos = Kaminari.paginate_array(favorite_videos, total_count: favorite_videos.size).page(params[:page]).per(Kaminari.config.default_per_page)
    end
end
