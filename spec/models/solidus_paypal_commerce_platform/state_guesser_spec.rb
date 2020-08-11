require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::StateGuesser, type: :model do
  let(:country) { create(:country, iso: "IT") }
  let!(:state) { create(:state, country: country, name: "Abruzzo") }

  describe "#guess" do
    context "with a guessable state error" do
      it "correctly guesses the state" do
        expect(
          described_class.new("Pescara", country).guess
        ).to eq state
      end

      it "guesses the state using an abbreviation" do
        expect(
          described_class.new("PE", country).guess
        ).to eq state
      end
    end

    context "with an unsolvable state error" do
      it "returns nil" do
        expect(
          described_class.new("Gondor", country).guess
        ).to eq nil
      end
    end

    context "with an already correct state" do
      it "returns the correct state" do
        expect(
          described_class.new("Abruzzo", country).guess
        ).to eq state
      end
    end
  end
end
