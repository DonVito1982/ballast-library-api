class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    payload[:exp] = Time.now.to_i + 60 * Session::DEFAULT_MINS
    JWT.encode(payload, ENV["JWT_KEY"])
  end

  def decoded_token
    header = request.headers['Authorization']
    if header
      token = header.split(" ")[1]
      begin
        JWT.decode(token, ENV["JWT_KEY"])
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
      @user.alive_sessions.count > 0 ? @user : nil
    end
  end

  def authorized
    unless !!current_user
      render json: { message: 'Please log in' }, status: :unauthorized
    end
  end
end
