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
end
