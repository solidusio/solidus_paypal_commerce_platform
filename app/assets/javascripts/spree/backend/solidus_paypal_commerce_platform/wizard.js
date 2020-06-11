/* global Spree, SolidusPaypalCommercePlatform */

// This needs to be filled before using the callback
SolidusPaypalCommercePlatform.nonce = null

// Returning from the setup wizard
SolidusPaypalCommercePlatform.onboardCallback = function(authCode, sharedId) {
  var nonce = SolidusPaypalCommercePlatform.nonce
  
  if (!nonce) 
    throw new Error("Please set SolidusPaypalCommercePlatform.nonce before calling this function.")

  Spree.ajax({
      url: '/solidus_paypal_commerce_platform/wizard',
      type: 'POST',
      data: {
        authCode: authCode,
        sharedId: sharedId,
        nonce: nonce
      },
      success: function(response) {
        window.location.href = response.redirectUrl;
      },
      error: function(response) {
        alert("Something went wrong!")
      }
  });
};
