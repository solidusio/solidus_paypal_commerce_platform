// Returning from the setup wizard
SolidusPaypalCommercePlatform.onboardCallback = function(authCode, sharedId) {
  Spree.ajax({
      url: '/solidus_paypal_commerce_platform/wizard',
      type: 'POST',
      data: {
        authCode: authCode,
        sharedId: sharedId,
        nonce:"0fb0e3e75e3deb58de8fb4e8dc27eb25ab2cbcabdb84"
      },
      success: function(response) {
        window.location.href = response.redirectUrl;
      },
      error: function(response) {
        alert("Something went wrong!")
      }
  });
};
