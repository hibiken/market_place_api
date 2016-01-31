require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  before(:each) do
    request.headers['Accept'] = "application/vnd.marketplace.v1"
  end

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eq(@user.email)
    end

    it "should respond with HTTP status 200" do
      expect(response.status).to eq(200)
    end
  end
end
