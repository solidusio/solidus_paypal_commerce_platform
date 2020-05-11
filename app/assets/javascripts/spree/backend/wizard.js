// Returning from the setup wizard
function onboardedCallback(authCode, sharedId) {
  fetch('/seller-server/login-seller', {
    method: 'POST',
    headers: {
      'content-type': 'application/json'
    },
    body: JSON.stringify({
      authCode: authCode,
      sharedId: sharedId
    })
  }).then(function(res) {
    if (!response.ok) {
      alert("Something went wrong!");
    }
  });
};
