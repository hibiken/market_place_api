require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create(:product) }
      get :index
    end

    it "returns all records from the database" do
      products_response = json_response
      expect(products_response[:products].size).to eq(4)
    end
  end


  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create(:product)
      get :show, id: @product.id
    end

    it "returns product data in JSON format" do
      product_response = json_response
      expect(product_response[:title]).to eq(@product.title)
    end

    it "redponds with HTTP status 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "POST #create" do
    context "when successfully created" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @product_attributes = FactoryGirl.attributes_for(:product, user: nil)
        request.headers['Authorization'] = @user.auth_token

        post :create, { user_id: @user.id, product: @product_attributes }
      end

      it "returns product data in JSON format" do
        product_response = json_response
        expect(product_response[:title]).to eq(@product_attributes[:title])
      end

      it "responds with HTTP status 201" do
        expect(response.status).to eq(201)
      end
    end

    context "when product is not created" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @invalid_attributes = { title: "Apple TV", price: "twenty hundred dollars" }
        request.headers['Authorization'] = @user.auth_token

        post :create, { user_id: @user.id, product: @invalid_attributes }
      end

      it "renders JSON with error messages" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include("is not a number")
      end

      it "responds with HTTP status 422" do
        expect(response.status).to eq(422)
      end
    end

    context "when not authorized" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @product_attributes = FactoryGirl.attributes_for(:product, user: nil)
        request.headers['Authorization'] = nil

        post :create, { user_id: @user.id, product: @product_attributes }
      end

      it "responds with HTTP status 401" do
        expect(response.status).to eq(401)
      end
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @product = FactoryGirl.create(:product, user: @user)
    end

    context "when successfully updated" do
      before(:each) do
        request.headers['Authorization'] = @user.auth_token
        patch :update, { user_id: @user.id, id: @product.id,
                         product: { title: "Updated title" } }
      end

      it "renders the json representation of the updated product" do
        product_response = json_response
        expect(product_response[:title]).to eq("Updated title")
      end

      it "responds with HTTP status 200" do
        expect(response.status).to eq(200)
      end
    end

    context "when user input is invalid" do
      before(:each) do
        request.headers['Authorization'] = @user.auth_token
        patch :update, { user_id: @user.id, id: @product.id,
                         product: { price: "two hundered" } }
      end

      it "renders json with error messages" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include("is not a number")
      end

      it "responds with HTTP status 422" do
        expect(response.status).to eq(422)
      end
    end

    context "when user is not logged in" do
      before(:each) do
        request.headers['Authorization'] = nil
        patch :update, { user_id: @user.id, id: @product.id,
                         product: { price: 900 } }
      end

      it "responds with HTTP status 401" do
        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is loggged in" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @product = FactoryGirl.create(:product, user: @user)
        request.headers['Authorization'] = @user.auth_token
        delete :destroy, { user_id: @user.id, id: @product.id }
      end

      it "responds with HTTP status 204" do
        expect(response.status).to eq(204)
      end
    end

    context "when user is not logged in" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @product = FactoryGirl.create(:product, user: @user)
        delete :destroy, { user_id: @user.id, id: @product.id }
      end

      it "responds with HTTP status 401" do
        expect(response.status).to eq(401)
      end
    end
  end
end
