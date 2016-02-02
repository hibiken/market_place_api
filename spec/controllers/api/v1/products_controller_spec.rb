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
end
