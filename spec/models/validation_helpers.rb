# spec/models/validation_helpers.rb

require 'spec_helper'

shared_examples "model validates parameter exists" do |params, key, message = "can't be blank"|
  let :subject do
    params.update(key => nil)
    described_class.new params
  end # let
  
  before :each do subject.valid?; end # force validation
  
  it { subject.should_not be_valid }
  it { subject.errors.messages[key].should include message }
  it { expect { described_class.create! params }.to raise_error ActiveRecord::RecordInvalid, /#{message}/i }
end # shared_examples validates parameter exists
