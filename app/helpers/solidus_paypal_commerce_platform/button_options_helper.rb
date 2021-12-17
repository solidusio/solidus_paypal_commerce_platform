# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  module ButtonOptionsHelper
    def preferred_paypal_button_color_options
      [["Gold", "gold"], ["Blue", "blue"], ["Silver", "silver"], ["White", "white"], ["Black", "black"]]
    end

    def preferred_paypal_button_size_options
      [["Small", "small"], ["Medium", "medium"], ["Large", "large"], ["Responsive", "responsive"]]
    end

    def preferred_paypal_button_shape_options
      [["Pill", "pill"], ["Rectangular", "rect"]]
    end

    def preferred_paypal_button_layout_options
      [["Vertical", "vertical"], ["Horizontal", "horizontal"]]
    end

    def preferred_venmo_standalone_options
      [['Enabled', 'Enabled'], ['Disabled', 'disabled']]
    end
  end
end
