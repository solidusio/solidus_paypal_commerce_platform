# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class StateGuesser
    def initialize(state_name, country)
      @state_name = state_name
      @country = country
    end

    def guess
      carmen_state = state_list.find{ |s| s.name == @state_name || s.code == @state_name }
      return if carmen_state.blank?

      guessed_state = spree_state(carmen_state.name)
      guessed_state || spree_state(carmen_state.parent.name)
    end

    private

    def state_list
      Carmen::Country.coded(@country.iso).subregions.map{ |s| [s, s.subregions] }.flatten
    end

    def spree_state(name)
      ::Spree::State.find_by(name: name)
    end
  end
end
