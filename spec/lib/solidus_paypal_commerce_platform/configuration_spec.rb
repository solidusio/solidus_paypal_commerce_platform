require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::Configuration do
  subject(:test_subject) { described_class.new }

  describe '#default_env' do
    it "uses ENV['PAYPAL_ENV'] when present" do
      expect(ENV).to receive(:[]).with("PAYPAL_ENV").and_return("foo").at_least(:once)
      expect(test_subject.default_env).to eq("foo")
    end

    it "falls back to Rails.env if ENV['PAYPAL_ENV'] is not set" do
      expect(ENV).to receive(:[]).with("PAYPAL_ENV").and_return(nil).at_least(:once)

      allow(Rails).to receive(:env).and_return("development".inquiry)
      expect(test_subject.default_env).to eq("sandbox")

      allow(Rails).to receive(:env).and_return("test".inquiry)
      expect(test_subject.default_env).to eq("sandbox")

      allow(Rails).to receive(:env).and_return("production".inquiry)
      expect(test_subject.default_env).to eq("live")

      allow(Rails).to receive(:env).and_return("staging".inquiry)
      expect{ test_subject.default_env }.to raise_error(described_class::InvalidEnvironment)
    end
  end

  describe '#env' do
    it 'returns a string inquirer' do
      expect(test_subject.env).to eq("sandbox")
      expect(test_subject.env).to be_sandbox

      test_subject.env = "live"
      expect(test_subject.env).to eq("live")
      expect(test_subject.env).to be_live

      test_subject.env = "sandbox"
      expect(test_subject.env).to eq("sandbox")
      expect(test_subject.env).to be_sandbox
    end

    it 'raises an error when assigned an unsupported value' do
      expect{ test_subject.env = "foo" }.to raise_error(described_class::InvalidEnvironment)
    end
  end

  describe '#env_class' do
    it 'changes based on the current env' do
      test_subject.env = "live"
      expect(test_subject.env_class).to eq(PayPal::LiveEnvironment)

      test_subject.env = "sandbox"
      expect(test_subject.env_class).to eq(PayPal::SandboxEnvironment)
    end
  end

  describe '#env_domain' do
    it 'changes based on the current env' do
      test_subject.env = "live"
      expect(test_subject.env_domain).to eq("www.paypal.com")

      test_subject.env = "sandbox"
      expect(test_subject.env_domain).to eq("www.sandbox.paypal.com")
    end
  end

  describe "#state_guesser_class" do
    before do
      stub_const('SolidusPaypalCommercePlatform::BetterStateGuesser', Class.new)
    end

    it "returns a class" do
      expect(test_subject.state_guesser_class).to be_a(Class)
    end

    it "is settable" do
      expect(test_subject.state_guesser_class).to eq(SolidusPaypalCommercePlatform::StateGuesser)

      test_subject.state_guesser_class = "SolidusPaypalCommercePlatform::BetterStateGuesser"

      expect(test_subject.state_guesser_class).to eq(SolidusPaypalCommercePlatform::BetterStateGuesser)
    end
  end

  describe "#partner_code" do
    it "returns the correct code" do
      expect(test_subject.partner_code).to eq("Solidus_PCP_SP")
    end
  end
end
