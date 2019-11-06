class ApplicationController < ActionController::Base
    helper_method :current_user
    before_action :login_rquired

    private
        def current_user
            @current_user ||= User.find(session[:user_id]) if session[:user_id]
        end

        def login_rquired
            unless current_user then
                flash[:error] = 'ログインしてください'
                redirect_to root_path
            end
        end
end
