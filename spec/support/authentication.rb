include Authentication

def authenticated_header(user)
  { "Authorization": "Bearer #{create_session_token(user)}" }
end
