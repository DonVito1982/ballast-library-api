require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
    let(:url) { "/users" }
    context "When creating users" do
      let(:user_params) do
        {
          username: Faker::Internet.username,
          password: Faker::Internet.password,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          role: "librarian"
        }
      end
      let(:parsed_body) { ActiveSupport::JSON.decode(response.body).symbolize_keys }

      it "Creates user" do
        expect {
          post url, params: user_params
        }.to change { User.count }.by(1)
      end

      it "responds with 201" do
        post url, params: user_params
        expect(response).to have_http_status :created
      end

      it "responds with new user information" do
        post url, params: user_params
        expect(parsed_body[:user]).to include("username" => user_params[:username])
        expect(parsed_body[:token]).to_not be_nil
        expect(parsed_body[:token].split(".").length).to eq 3
      end
    end
  end

  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end
end
