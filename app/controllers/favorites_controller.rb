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
end
