require 'spec_helper'
require 'active_record'

describe User do
  before :each do
    @params = {
      :email => "test_email@test.com",
      :password => "test_password",
      :password_confirmation => "test_password",
    } # end params
  end # before :each
  
  context "creation and validation:" do
    it { expect { described_class.create! @params.clone.update(:email => nil) }.to raise_error ActiveRecord::RecordInvalid }
    it { expect { described_class.create! @params.clone.update(:email => "invalid_email") }.to raise_error ActiveRecord::RecordInvalid }
    it { expect { described_class.create! @params.clone.update(:password => nil) }.to raise_error ActiveRecord::RecordInvalid }
    it { expect { described_class.create! @params.clone.update(:password_confirmation => nil) }.to raise_error ActiveRecord::RecordInvalid }
    it { expect { described_class.create! @params.clone.update(:password_confirmation => "fake_password") }.to raise_error ActiveRecord::RecordInvalid }
    
    it { expect { described_class.create! @params }.not_to raise_error }
  end # context
  
  context "once instantiated" do
    before :each do
      @user = described_class.new @params
    end # before :each
    
    subject { @user }
    
    it { subject.should be_valid }
    it { subject.save.should be true }
  end # context
  
  context "once saved" do
    before :each do
      @user = described_class.create @params
    end # before :each
    
    subject { @user }
    
    it { subject.authenticate(@params[:password]).should be @user }
    it { subject.authenticate("fake_password").should be false }
    it { subject.authenticate(nil).should be false }
  end # context
end # describe User
