require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  before(:each) do
    request.headers['Accept'] = "application/vnd.marketplace.v1, #{Mime::JSON}"
    request.headers['Content-Type'] = Mime::JSON.to_s
  end

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      get :show, id: @user.id
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eq(@user.email)
    end

    it "responds with HTTP status 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    context "when user is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for(:user)
        post :create, { user: @user_attributes }
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eq(@user_attributes[:email])
      end

      it "responds with HTTP status 201" do
        expect(response.status).to eq(201)
      end
    end

    context "when user is not created" do
      before(:each) do
        @invalid_user_attributes = { email: "",
                                    password: "12345678",
                                    password_confirmation: "12345678" }
        post :create, { user: @invalid_user_attributes }
      end

      it "renders an error json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders an error json with explanation" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include("can't be blank")
      end

      it "responds with HTTP status 422" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PUT/PATCH #update" do
    context "when successfully updated" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        request.headers["Authorization"] = @user.auth_token
        patch :update, { id: @user.id,
                        user: { email: "newaddress@example.com" } }
      end

      it "renders the json representation of the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eq("newaddress@example.com")
      end

      it "responsds with HTTP status 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when update is unsuccessful" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        request.headers["Authorization"] = @user.auth_token
        patch :update, { id: @user.id,
                         user: { email: "bademail.com" } }
      end

      it "renders n error json" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include("is invalid")
      end

      it "responds with HTTP status 422" do
        expect(response.status).to eq(422)
      end
    end

    context "when user is not logged in" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        request.headers["Authorization"] = nil
        patch :update, { id: @user.id,
                         user: { email: "newaddress@email.com" } }
      end

      it "responds with HTTP status 401" do
        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE #destroy" do

    context "when logged in" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        request.headers["Authorization"] = @user.auth_token
        delete :destroy, { id: @user.id }
      end

      it "responds with HTTP status 204" do
        # 204 :no_content
        expect(response.status).to eq(204)
      end
    end

    context "when user is not logged in" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        request.headers["Authorization"] = nil
        delete :destroy, { id: @user.id }
      end

      it "responds with HTTP status 401" do
        expect(response.status).to eq(401)
      end

    end
  end
end
