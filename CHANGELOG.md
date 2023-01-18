# Changelog

## [v1.0.0.beta3](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v1.0.0.beta3) (2023-01-18)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v1.0.0.beta2...v1.0.0.beta3)

**Fixed bugs:**

- Allow cancelling orders \(v1 port of \#180\) [\#182](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/182)
- Preferred paypal button color error message should be translated [\#178](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/178)
- Allow cancelling orders [\#183](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/183) ([kennyadsl](https://github.com/kennyadsl))

**Closed issues:**

- Make the Venmo button testable from outside US contries [\#137](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/137)

**Merged pull requests:**

- \[v1\] Allow to use the auto\_capture global preference [\#186](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/186) ([kennyadsl](https://github.com/kennyadsl))
- Uniform installer with Solidus Starter Frontend [\#184](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/184) ([kennyadsl](https://github.com/kennyadsl))
- Do not break custom pricing options classes [\#181](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/181) ([mamhoff](https://github.com/mamhoff))
- Fix: preferred\_paypal\_button\_color error message should be translated dynamically [\#179](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/179) ([gsmendoza](https://github.com/gsmendoza))
- Add instructions on how to use the PayPal sandbox [\#177](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/177) ([elia](https://github.com/elia))

## [v1.0.0.beta2](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v1.0.0.beta2) (2022-12-12)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v1.0.0.beta1...v1.0.0.beta2)

**Fixed bugs:**

- wizard doesn't create payment method in v1.0.0.beta1 and no partial. [\#174](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/174)
- Solidus 3.2 doesn't install SPCP's checkout page when PayPal is chosen as the payment method [\#172](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/172)

**Closed issues:**

- Hide the installer option for copying specs [\#175](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/175)
- Decide about the testing approach for extensions that involve SSF code [\#171](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/171)
- Release 1.0.0.beta1 compatible with the new starter frontend [\#170](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/170)

**Merged pull requests:**

- Hide the installer `--specs=…` option [\#176](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/176) ([elia](https://github.com/elia))
- Remove solidus prefix from component names [\#173](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/173) ([gsmendoza](https://github.com/gsmendoza))
- Bugfixes and improvements \(extracted from the SSF support branch\) [\#168](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/168) ([elia](https://github.com/elia))
- Reorganize the install generator and deprecate `--skip-migrations` [\#167](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/167) ([elia](https://github.com/elia))
- Setup compatibility with the starter frontend [\#166](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/166) ([elia](https://github.com/elia))
- Move 'shipping\_preference' preference under PaypalOrder\#to\_json [\#152](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/152) ([retsef](https://github.com/retsef))
- Truncate the product name to 127 characters [\#139](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/139) ([DanielePalombo](https://github.com/DanielePalombo))
- Fix issue on international transactions [\#129](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/129) ([jtapia](https://github.com/jtapia))

## [v1.0.0.beta1](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v1.0.0.beta1) (2022-12-05)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.6.0...v1.0.0.beta1)

**Closed issues:**

- Release 0.6 and attach that version to a different branch [\#169](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/169)

## [v0.6.0](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.6.0) (2022-11-25)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.5.0...v0.6.0)

**Fixed bugs:**

- Gem does not support Ruby 3.0 [\#145](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/145)

**Closed issues:**

- Invalid string length error [\#135](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/135)
- PayPal SDK JS Error: Disallowed query param: shipping\_preference [\#133](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/133)

## [v0.5.0](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.5.0) (2022-10-07)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.4.0...v0.5.0)

**Merged pull requests:**

- Update links after moving to @solidusio [\#164](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/164) ([elia](https://github.com/elia))
- Assign created orders to users / Require Solidus 3 & Ruby 2.7 [\#163](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/163) ([elia](https://github.com/elia))
- Fix master, import paypal-checkout-sdk [\#161](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/161) ([cpfergus1](https://github.com/cpfergus1))
- Update to use forked solidus\_frontend when needed [\#160](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/160) ([waiting-for-dev](https://github.com/waiting-for-dev))
- Fix paypal\_order name address bug [\#153](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/153) ([RyanofWoods](https://github.com/RyanofWoods))

## [v0.4.0](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.4.0) (2022-06-03)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.3.2...v0.4.0)

**Closed issues:**

- Gem has RuboCop warnings [\#144](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/144)
- Silent Failure In JS [\#130](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/130)
- Not Applying Sales Tax [\#126](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/126)

**Merged pull requests:**

- Bump SolidusPaypalCommercePlatform to 0.4.0 [\#158](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/158) ([gsmendoza](https://github.com/gsmendoza))
- Fix Rails 7 autoloading issues with SolidusPaypalCommercePlatform [\#156](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/156) ([gsmendoza](https://github.com/gsmendoza))
- Block \#capture on Pending Payments" [\#155](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/155) ([Naokimi](https://github.com/Naokimi))
- Block \#capture on PayPal PENDING Payments [\#154](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/154) ([Naokimi](https://github.com/Naokimi))
- Change Venmo integration to use Venmo standalone [\#151](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/151) ([RyanofWoods](https://github.com/RyanofWoods))
- Allow enable\_venmo preference to have default Venmo behaviour [\#148](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/148) ([RyanofWoods](https://github.com/RyanofWoods))
- Fix RuboCop warnings [\#147](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/147) ([RyanofWoods](https://github.com/RyanofWoods))
- Revert "Allow Ruby 3" [\#146](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/146) ([RyanofWoods](https://github.com/RyanofWoods))
- Add Venmo as payment option [\#138](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/138) ([RyanofWoods](https://github.com/RyanofWoods))
- Wizard\#logo use `image_path` over `image_url`. [\#131](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/131) ([essn](https://github.com/essn))

## [v0.3.2](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.3.2) (2021-05-11)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.3.1...v0.3.2)

**Merged pull requests:**

- Update solidus using solidus\_dev\_support [\#124](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/124) ([DanielePalombo](https://github.com/DanielePalombo))
- Add NO\_SHIPPING to shipping preference [\#123](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/123) ([DanielePalombo](https://github.com/DanielePalombo))
- Support solidus 3.0 [\#122](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/122) ([DanielePalombo](https://github.com/DanielePalombo))

## [v0.3.1](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.3.1) (2021-04-20)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.3.0...v0.3.1)

**Merged pull requests:**

- Allow Solidus 3 [\#121](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/121) ([kennyadsl](https://github.com/kennyadsl))

## [v0.3.0](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.3.0) (2021-03-16)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.2.2...v0.3.0)

**Closed issues:**

- Prepare Solidus Paypal Commerce Platform for Solidus 3.0 [\#115](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/115)

**Merged pull requests:**

- Use new factories loading method [\#118](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/118) ([kennyadsl](https://github.com/kennyadsl))
- Update extension for Solidus 3.0 [\#117](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/117) ([seand7565](https://github.com/seand7565))

## [v0.2.2](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.2.2) (2020-11-20)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.2.1...v0.2.2)

**Implemented enhancements:**

- Make the PayPal messaging component a bit more modular [\#112](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/112)
- Implement and QA Paypal credit solutions [\#99](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/99)

**Closed issues:**

- Simulated Address Info in Live Order [\#104](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/104)

**Merged pull requests:**

- Relax SolidusWebhooks dependency [\#114](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/114) ([kennyadsl](https://github.com/kennyadsl))
- Add information about paypal credit messaging to readme [\#113](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/113) ([seand7565](https://github.com/seand7565))

## [v0.2.1](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.2.1) (2020-11-09)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.2.0...v0.2.1)

**Closed issues:**

- There was a problem connecting with paypal.  [\#107](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/107)
- Bad Request \(400\) when opening PayPal Payment Popup \(eg clicking Pay with PayPal during checkout\) [\#103](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/103)

**Merged pull requests:**

- Move and rename address decorator [\#111](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/111) ([seand7565](https://github.com/seand7565))
- Constrain solidus\_support to 0.5.1 or greater [\#110](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/110) ([seand7565](https://github.com/seand7565))
- Add currency to PayPal SDK URL [\#108](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/108) ([seand7565](https://github.com/seand7565))
- Update specs to comply with new rubocop regulations [\#106](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/106) ([seand7565](https://github.com/seand7565))
- Add address only to initial PayPal request [\#105](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/105) ([seand7565](https://github.com/seand7565))

## [v0.2.0](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.2.0) (2020-10-13)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.2.0.alpha.1...v0.2.0)

**Merged pull requests:**

- Add PayPal messaging component [\#102](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/102) ([seand7565](https://github.com/seand7565))
- Add partner ID attribute to SDK javascript tag [\#101](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/101) ([seand7565](https://github.com/seand7565))
- Set current\_order\_id and token during payment step [\#100](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/100) ([MFRWDesign](https://github.com/MFRWDesign))
- Remove incorrect/unclear info from README [\#98](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/98) ([seand7565](https://github.com/seand7565))
- Update the extension with the latest solidus\_dev\_support defaults [\#95](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/95) ([elia](https://github.com/elia))
- Add skip migration option to installer [\#94](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/94) ([seand7565](https://github.com/seand7565))
- Update README to reflect referral fee [\#93](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/93) ([seand7565](https://github.com/seand7565))

## [v0.2.0.alpha.1](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.2.0.alpha.1) (2020-10-07)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.1.0...v0.2.0.alpha.1)

**Closed issues:**

- README lists two different types of PayPal credentials [\#97](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/97)
- `paypal_email_confirmed` is not an actual preference [\#96](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/96)
- Make this extension the default option for Solidus [\#88](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/88)

## [v0.1.0](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.1.0) (2020-09-03)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/v0.0.1...v0.1.0)

**Merged pull requests:**

- Temporarily switch from apparition to cuprite [\#92](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/92) ([elia](https://github.com/elia))
- Update links after moving the repo to solidusio-contrib [\#91](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/91) ([elia](https://github.com/elia))
- Add a configurable state\_guesser class to guess states [\#90](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/90) ([seand7565](https://github.com/seand7565))
- Add better error handling to button\_actions.js [\#89](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/89) ([seand7565](https://github.com/seand7565))

## [v0.0.1](https://github.com/solidusio/solidus_paypal_commerce_platform/tree/v0.0.1) (2020-08-10)

[Full Changelog](https://github.com/solidusio/solidus_paypal_commerce_platform/compare/11111204cc53e8bcfd365ae70506c07940446b0c...v0.0.1)

**Implemented enhancements:**

- Frontend users should be able to check out using PayPal [\#6](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/6)
- Admin users should be able to style the PayPal buttons on the payment\_method show page [\#5](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/5)
- Webhooks [\#83](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/83) ([elia](https://github.com/elia))
- Display paypal email to customer on confirmation [\#54](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/54) ([seand7565](https://github.com/seand7565))
- Use an env accessor to control live/sandbox urls and classes [\#31](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/31) ([elia](https://github.com/elia))
- Add response object to API calls to PayPal [\#30](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/30) ([seand7565](https://github.com/seand7565))

**Fixed bugs:**

- Users can check out with invalid payment [\#19](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/19)
- Have different nonce for every click of the wizard button [\#87](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/87) ([elia](https://github.com/elia))
- Correctly communicate errors when updating shipping rates [\#86](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/86) ([elia](https://github.com/elia))
- Add deface to deps [\#57](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/57) ([elia](https://github.com/elia))

**Closed issues:**

- Add something to the README about backend payments [\#75](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/75)
- Explore enabling the payment method by default [\#71](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/71)
- Explore subscribing to webhooks [\#70](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/70)
- We're using the wrong ID for paypal\_order\_id [\#69](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/69)
- Handle instrument declined errors [\#68](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/68)
- Extend lightbox during customer payment [\#63](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/63)
- Add this extension to demo store for integration team walkthrough [\#49](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/49)
- Store PayPal Debug ID [\#48](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/48)
- PayPal email address needs to be included on the confirm step [\#47](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/47)
- Digital goods should be set as not requiring shipment [\#46](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/46)
- Allow checkout on product/cart page to complete the order [\#44](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/44)
- PayPal uses different states than Solidus for some countries [\#38](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/38)
- Validate amount charged with PayPal [\#37](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/37)
- Allow order simulator to be a configurable class [\#36](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/36)
- Admin users have the option to edit payment amount [\#29](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/29)
- Add PayPal button to product page [\#27](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/27)
- Add PayPal button to cart page [\#26](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/26)
- Add `commit=false` to javascript SDK URL [\#18](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/18)
- Explore using Rails secrets to encode and decrypt PayPal client id and secret [\#17](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/17)
- Backend users should be able to checkout & admin payments [\#15](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/15)
- Change static sandbox URL and objects to dynamic [\#14](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/14)
- PayPal response address change [\#13](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/13)
- Ensure the email is verified before activating the payment method [\#9](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/9)
- Add a URL generator for the PayPal JS SDK [\#8](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/8)
- Allow users to onboard with PayPal [\#1](https://github.com/solidusio/solidus_paypal_commerce_platform/issues/1)

**Merged pull requests:**

- Use live partner ids [\#85](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/85) ([elia](https://github.com/elia))
- Update README to account for checkouts without a confirmation step [\#84](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/84) ([seand7565](https://github.com/seand7565))
- Replace order simulator with something simpler [\#82](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/82) ([seand7565](https://github.com/seand7565))
- Cleanup [\#81](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/81) ([elia](https://github.com/elia))
- Send line\_item and shipping promotions to PayPal [\#80](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/80) ([seand7565](https://github.com/seand7565))
- Change outstanding\_balance to total in order total checker [\#79](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/79) ([seand7565](https://github.com/seand7565))
- Add overlay to ease transition to confirmation page [\#78](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/78) ([seand7565](https://github.com/seand7565))
- Default available\_to\_users to true [\#77](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/77) ([seand7565](https://github.com/seand7565))
- Add info about PayPal Terminal to README [\#76](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/76) ([seand7565](https://github.com/seand7565))
- Return a payment declined error on the frontend [\#74](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/74) ([seand7565](https://github.com/seand7565))
- Only use the necessary data to let the spec pass [\#73](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/73) ([elia](https://github.com/elia))
- Display capture\_id instead of order\_id to admin user [\#72](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/72) ([seand7565](https://github.com/seand7565))
- Use options instead of preferences [\#67](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/67) ([seand7565](https://github.com/seand7565))
- Update README to reflect new preferences [\#66](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/66) ([seand7565](https://github.com/seand7565))
- Add version to cache\_key [\#65](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/65) ([seand7565](https://github.com/seand7565))
- Include payment method information in pricing options cache key [\#62](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/62) ([seand7565](https://github.com/seand7565))
- Only use available payment\_methods [\#61](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/61) ([seand7565](https://github.com/seand7565))
- Explicitly require deface [\#60](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/60) ([elia](https://github.com/elia))
- Verify email address is verified before allowing payment method to be available [\#59](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/59) ([seand7565](https://github.com/seand7565))
- Use the ORB definition of lint-code [\#58](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/58) ([elia](https://github.com/elia))
- Send amount of payment to PayPal on capture [\#56](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/56) ([seand7565](https://github.com/seand7565))
- Verify amount to charge with order total [\#55](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/55) ([seand7565](https://github.com/seand7565))
- Linting the project with rubocop [\#53](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/53) ([elia](https://github.com/elia))
- Add PayPal Debug ID to log entries [\#52](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/52) ([seand7565](https://github.com/seand7565))
- Fix PayPal request success message en.yml paths [\#51](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/51) ([seand7565](https://github.com/seand7565))
- Add configuration options to SolidusPaypalCommercePlatform [\#50](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/50) ([seand7565](https://github.com/seand7565))
- Add PayPal button to product page [\#45](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/45) ([seand7565](https://github.com/seand7565))
- Add PayPal Button To Cart Page [\#43](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/43) ([seand7565](https://github.com/seand7565))
- Add ability to change address on PayPal [\#42](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/42) ([seand7565](https://github.com/seand7565))
- Add a basic codecov config to show commit status [\#41](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/41) ([elia](https://github.com/elia))
- Add CI & Coverage badges to the readme [\#40](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/40) ([elia](https://github.com/elia))
- Rely on sdk request classes [\#39](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/39) ([elia](https://github.com/elia))
- Use "commit=false" in the JS SDK url when "confirm" step is present [\#33](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/33) ([elia](https://github.com/elia))
- Renames: Gateway → PaymentMethod / Requests → Gateway [\#32](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/32) ([elia](https://github.com/elia))
- Add PayPal Virtual Terminal notice to backend [\#25](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/25) ([seand7565](https://github.com/seand7565))
- Add missing partials necessary for backend [\#24](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/24) ([seand7565](https://github.com/seand7565))
- Add the ability to void authorized payments [\#23](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/23) ([seand7565](https://github.com/seand7565))
- Fix order controller response [\#22](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/22) ([seand7565](https://github.com/seand7565))
- Add refund ability to admin payment management [\#21](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/21) ([seand7565](https://github.com/seand7565))
- Fixes and refactoring [\#20](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/20) ([elia](https://github.com/elia))
- Add ability for admin users to customize paypal button [\#16](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/16) ([seand7565](https://github.com/seand7565))
- Restore the generic bin/rails command [\#11](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/11) ([elia](https://github.com/elia))
- Add PayPal buttons to frontend checkout flow [\#10](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/10) ([seand7565](https://github.com/seand7565))
- Update readme to reflect onboarding and wizards 🧙 [\#4](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/4) ([seand7565](https://github.com/seand7565))
- Add setup wizard for paypal commerce platform [\#3](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/3) ([seand7565](https://github.com/seand7565))
- Add paypal\_commerce\_platform as a payment method [\#2](https://github.com/solidusio/solidus_paypal_commerce_platform/pull/2) ([seand7565](https://github.com/seand7565))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
