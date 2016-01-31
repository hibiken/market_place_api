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
end
