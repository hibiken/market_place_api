require 'rails_helper'

RSpec.describe Api::V1::SessionsController do
  before(:each) do
    request.headers['Accept'] = "application/vnd.marketplace.v1, #{Mime::JSON}"
    request.headers['Content-Type'] = Mime::JSON.to_s

    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    before(:each) do
      @user = FactoryGirl.create(:user, password: "12345678")
    end

    context "when the credentials are correct" do
      before(:each) do
        credentials = { email: @user.email, password: "12345678" }
        post :create, { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(json_response[:auth_token]).to eq(@user.auth_token)
      end

      it "responds with HTTP status 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when the credentials are incorrect" do
      before(:each) do
        credentials = { email: @user.email, password: "invalidpassword" }
        post :create, { session: credentials }
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eq("Invalid email or password")
      end

      it "responds with HTTP status 422" do
        expect(response.status).to eq(422)
      end
    end
  end
end
