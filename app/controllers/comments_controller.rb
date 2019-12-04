class CommentsController < ApplicationController
    def new
        # createのvalidatesでチェックにかかる場合はflashでcommentが返される
        @user = User.find(session[:user_id])
        @video = Video.find(params[:video_id])
        @comment = Comment.new(flash[:comment])
    end

    def create
        @video = Video.find(params[:video_id])

        # 正当なユーザーであることを確認
        unless User.find(session[:user_id]).equal_token?(session[:token])
            flash[:error] = 'コメントの投稿に失敗しました / 再ログイン後に再投稿してください'
            redirect_to new_video_comment_path(@video) and return
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
                comment: comment,
            }
        end
    end

    def edit
        # updateのvalidatesでチェックにかかる場合はflashでcommentが返される
        @user = User.find(session[:user_id])
        @video = Video.find(params[:video_id])
        @comment = flash[:comment].blank? ? Comment.find(params[:id]) : Comment.new(flash[:comment])
    end

    def update
        @video = Video.find(params[:video_id])

        # 正当なユーザーであることを確認
        unless User.find(session[:user_id]).equal_token?(session[:token])
            flash[:error] = 'コメントの投稿に失敗しました / 再ログイン後に再投稿してください'
            redirect_to edit_video_comment_path(@video) and return
        end

        # コメントの更新
        comment = Comment.find(params[:id])
        if comment.update(comment_params)
            flash[:notice] = 'コメントを更新しました'
            redirect_to video_path(@video)
        else
            redirect_to edit_video_comment_path(@video), flash: {
                validates: comment.errors.full_messages,
                comment: comment,
            }
        end
    end

    def destroy
        @video = Video.find(params[:video_id])

        # 正当なユーザーであることを確認
        unless User.find(session[:user_id]).equal_token?(session[:token])
            flash[:error] = 'コメントの削除に失敗しました / 再ログイン後に再実行してください'
            redirect_to video_path(@video) and return
        end

        comment = Comment.find(params[:id])
        comment.destroy
        redirect_to video_path(@video), notice: 'コメントが削除されました'
    end

    def index
        @user = User.find(params[:user_id])

        # 正当なユーザーであることを確認
        unless @user.equal_token?(session[:token])
          flash[:error] = 'マイページへのアクセスに失敗しました / 再ログイン後にやり直してください'
          redirect_to root_path and return
        end

        @comments = Comment.where(user_id: @user.id).includes([:user, :video]).page(params[:page])
    end

    def from_my_page_destroy
        @user = User.find(params[:user_id])

        # 正当なユーザーであることを確認
        unless User.find(session[:user_id]).equal_token?(session[:token])
            flash[:error] = 'コメントの削除に失敗しました / 再ログイン後に再実行してください'
            redirect_to user_comments_path(@user) and return
        end

        comment = Comment.find(params[:id])
        comment.destroy
        redirect_to user_comments_path(@user), notice: 'コメントが削除されました'
    end

    private
        def comment_params
            params.require(:comment).permit(:comment, :user_id, :video_id)
        end
end
