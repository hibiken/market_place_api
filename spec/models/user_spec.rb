require 'rails_helper'

RSpec.describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }
  
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe "validations" do
    it "requires email to be present" do
      @user.email = ""
      expect(@user).not_to be_valid
    end
  end

  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eq("auniquetoken123")
    end

    it "generates another token when one has already been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eq(existing_user.auth_token)
    end
  end
end
