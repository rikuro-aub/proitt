class SessionsController < ApplicationController
    def create
        auth = request.env['omniauth.auth']
        token_digest = Digest::SHA256.hexdigest auth['credentials']['token']

        if user = User.find_by(user_id: auth['uid']) then
            # 取得したGitHubのユーザー情報が更新されている可能性がある場合はここで同期する
            user.update(name: auth['info']['nickname']) if user.name != auth['info']['nickname']
        else
            user = User.create_with_omniauth(auth)
        end

        user.update(token_digest: token_digest)
        session[:user_id] = user.id

        redirect_to root_path, notice: 'ログインしました'
    end

    def destroy
        reset_session
        redirect_to root_path, notice: 'ログアウトしました'
    end
end
