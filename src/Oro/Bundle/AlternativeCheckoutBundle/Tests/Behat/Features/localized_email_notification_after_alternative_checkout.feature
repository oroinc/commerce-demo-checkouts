@regression
@ticket-BAP-17336
@fixture-OroUserBundle:UserLocalizations.yml
@fixture-OroFlatRateShippingBundle:FlatRateIntegration.yml
@fixture-OroPaymentTermBundle:PaymentTermIntegration.yml
@fixture-OroWarehouseBundle:AlternativeCheckout.yml
@fixture-OroWarehouseBundle:Checkout.yml

Feature: Localized email notification after alternative checkout
  In order to finish alternative checkout
  As a buyer
  I should receive order confirmation email in predefined language

  Scenario: Prepare configuration with different languages on each level
    Given sessions active:
      | Admin | first_session  |
      | User  | second_session |
    When I proceed as the Admin
    And I login as administrator
    And I go to System / Configuration
    And I follow "System Configuration/General Setup/Localization" on configuration sidebar
    And I fill form with:
      | Enabled Localizations | [English (United States), German Localization, French Localization] |
      | Default Localization  | English (United States)                                             |
    And I submit form
    Then I should see "Configuration saved" flash message
    When I go to System / Websites
    And click Configuration "Default" in grid
    And I follow "System Configuration/General Setup/Localization" on configuration sidebar
    And uncheck "Use Organization" for "Default Localization" field
    And I fill form with:
      | Default Localization | German Localization |
    And I submit form
    Then I should see "Configuration saved" flash message
    When I go to System / Workflows
    And I click "Activate" on row "Alternative Checkout" in grid
    And I click "Activate" in modal window
    Then I should see "Workflow activated" flash message
    When I go to System / Emails / Templates
    And I filter Template Name as is equal to "order_confirmation_email"
    And I click "edit" on first row in grid
    And fill "Email Template Form" with:
      | Subject | English Order Confirmation Subject |
      | Content | English Order Confirmation Body    |
    And I click "French"
    And fill "Email Template Form" with:
      | Subject Fallback | false                             |
      | Content Fallback | false                             |
      | Subject          | French Order Confirmation Subject |
      | Content          | French Order Confirmation Body    |
    And I click "German"
    And fill "Email Template Form" with:
      | Subject Fallback | false                             |
      | Content Fallback | false                             |
      | Subject          | German Order Confirmation Subject |
      | Content          | German Order Confirmation Body    |
    And I submit form
    Then I should see "Template saved" flash message

  Scenario: After alternative checkout customer user should get an email in a language currently used on website
    # Request approval
    Given I proceed as the User
    When I signed in as MarleneSBradley@example.org on the store frontend
    And I select "French Localization" localization
    And I open page with shopping list List Threshold
    And I click "Create Order"
    And I select "Fifth avenue, 10115 Berlin, Germany" on the "Billing Information" checkout step and press Continue
    And I select "Fifth avenue, 10115 Berlin, Germany" on the "Shipping Information" checkout step and press Continue
    And I check "Flat Rate" on the "Shipping Method" checkout step and press Continue
    And I check "Payment Terms" on the "Payment" checkout step and press Continue
    And I fill "Checkout Order Review Form" with:
      | PO Number              | TEST_PO_NUMBER     |
      | Notes                  | Customer test note |
      | Do not ship later than | Jul 1, 2018        |
    And I click on empty space
    And I check "Delete this shopping list after submitting order" on the "Order Review" checkout step and press Request Approval
    Then I should see "You exceeded the allowable amount of $5000."
    When I click "Request Approval"
    Then I should see "Pending approval"

    # Approve order
    Given I proceed as the Admin
    When I signed in as NancyJSallee@example.org on the store frontend
    And I select "English (United States)" localization
    And I click "Account Dropdown"
    And click "Order History"
    And click "Check Out" on row "List Threshold" in grid
    And click "Approve Order"

    # Submit order
    And I proceed as the User
    And reload the page
    Then I should see "Approved at"
    When click "Submit Order"
    Then Email should contains the following:
      | To      | MarleneSBradley@example.org       |
      | Subject | French Order Confirmation Subject |
      | Body    | French Order Confirmation Body    |
