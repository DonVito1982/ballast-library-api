class AuthController < ApplicationController
  skip_before_action :authorized, only: :login
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def login
    @user = User.find_by!(username: login_params[:username])
    if @user.authenticate(login_params[:password])
      token = encode_token(user_id: @user.id)
      @user.create_fresh_session
      render json: {
        user: UserSerializer.new(@user),
        token: token
      }, status: :accepted
    else
      render json: { message: "Incorrect password" }, status: :unauthorized
    end
  end

  def logout
    current_user.close_live_sessions
  end

  private

  def login_params
    params.permit(:username, :password)
  end

  def handle_record_not_found(e)
    render json: { message: "User does not exist" }, status: :unauthorized
  end
end
