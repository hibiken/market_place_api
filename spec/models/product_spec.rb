require 'rails_helper'

RSpec.describe Product do
  describe "validations" do
    let(:product) { FactoryGirl.build(:product) }

    it "is valid" do
      expect(product).to be_valid
    end

    it "requires title to be present" do
      product.title = nil
      expect(product).to be_invalid
    end

    it "requires price to be present" do
      product.price = nil
      expect(product).to be_invalid
    end

    it "requires price to be a number" do
      product.price = "hundred dollars"
      expect(product).to be_invalid
    end

    it "requires price to be greater than or equal to 0" do
      product.price = -10
      expect(product).to be_invalid
    end

    it "requires user_id to be present" do
      product.user_id = nil
      expect(product).to be_invalid
    end
  end
end
