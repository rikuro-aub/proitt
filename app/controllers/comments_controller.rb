class CommentsController < ApplicationController
    def new
        @user = User.find(session[:user_id])
        @video = Video.find(params[:video_id])
        @comment = Comment.new(flash[:comment])
    end

    def create
        @video = Video.find(params[:video_id])

        # 正当なユーザーであることを確認
        unless User.find(session[:user_id]).equal_token?(session[:token])
            flash[:error] = 'コメントの投稿に失敗しました / 再ログイン後に再投稿してください'
            redirect_to new_video_comment_path(@video)
        end

        # コメントの登録
        comment = @video.comments.build(comment_params)
        comment.user_id = session[:user_id]
        if comment.save
            flash[:notice] = 'コメントを投稿しました'
            redirect_to video_path(@video)
        else
            redirect_to new_video_comment_path(@video), flash: {
                validates: comment.errors.full_messages,
                commnet: comment,
            }
        end
    end

    private
        def comment_params
            params.require(:comment).permit(:comment, :user_id, :video_id)
        end
end
