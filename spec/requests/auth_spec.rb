require 'rails_helper'

RSpec.describe "Auths", type: :request do
  describe "POST /auth/login" do
    let(:url) { auth_login_path }
    let(:user) { create(:user, password: "pass%456", first_name: "First",
                        last_name: "Lastname", role: "member",
                        username: "user1") }

    it "fails to log with invalid credentials" do
      invalid_params = { username: user.username, password: "invalid%456" }
      post url, params: invalid_params
      expect(response).to have_http_status :unauthorized # http code 401
    end

    context "when logging in with valid credentials" do
      let(:valid_params) { { username: user.username, password: "pass%456" } }
      let(:parsed_body) { ActiveSupport::JSON.decode(response.body).symbolize_keys }

      before { post url, params: valid_params }

      it "the request is accepted" do
        expect(response).to have_http_status :accepted # http code 202
      end

      it "responds with user information" do
        expect(parsed_body[:user]).to include("username" => user.username)
        expect(parsed_body[:token]).to_not be_nil
        expect(parsed_body[:token].split(".").length).to eq 3
      end
    end
  end

  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end
end
