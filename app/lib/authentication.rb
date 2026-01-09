module Authentication
  TOKEN_MINUTES = 4

  def self.included(base)
    base.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def create_session_token(user)
      user.create_fresh_session
      encode_jwt_token(user_id: user.id)
    end

    def encode_jwt_token(payload)
      payload[:exp] = Time.now.to_i + 60 * TOKEN_MINUTES
      JWT.encode(payload, ENV["JWT_KEY"])
    end
  end
end
