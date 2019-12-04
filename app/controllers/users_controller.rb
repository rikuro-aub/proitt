class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    # 正当なユーザーであることを確認
    unless @user.equal_token?(session[:token])
      flash[:error] = 'マイページへのアクセスに失敗しました / 再ログイン後にやり直してください'
      redirect_to root_path and return
    end
  end

  def delete
    @user = User.find(params[:user_id])

    # 正当なユーザーであることを確認
    unless @user.equal_token?(session[:token])
      flash[:error] = 'マイページへのアクセスに失敗しました / 再ログイン後にやり直してください'
      redirect_to root_path and return
    end
  end

  def destroy
    @user = User.find(params[:id])

    # 正当なユーザーであることを確認
    unless @user.equal_token?(session[:token])
      flash[:error] = 'マイページへのアクセスに失敗しました / 再ログイン後にやり直してください'
      redirect_to root_path and return
    end

    # 入力ユーザー名が一致しない場合
    user = User.where(id: params[:id], name: params[:user][:user_name])
    unless user.present?
      flash[:error] = '削除に失敗しました / 入力されたユーザー名が一致しません'
      redirect_to user_delete_path(@user) and return
    end

    user.destroy_all
    reset_session
    flash[:notice] = '削除に成功しました'
    redirect_to root_path and return
  end
end
