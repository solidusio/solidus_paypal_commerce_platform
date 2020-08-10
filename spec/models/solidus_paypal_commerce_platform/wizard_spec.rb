require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::Wizard do
  describe "#nonce" do
    it 'is between 45 and 128 chars long' do
      expect(subject.nonce.size).to be_between(45, 128)
    end
  end
end
