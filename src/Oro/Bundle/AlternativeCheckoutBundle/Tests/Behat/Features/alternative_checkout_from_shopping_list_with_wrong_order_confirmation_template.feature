@regression
@ticket-BB-16109
@fixture-OroFlatRateShippingBundle:FlatRateIntegration.yml
@fixture-OroPaymentTermBundle:PaymentTermIntegration.yml
@fixture-OroAlternativeCheckoutBundle:AlternativeCheckout.yml

Feature: Alternative Checkout From Shopping List With Wrong Order Confirmation Template
  In order to create order from Shopping List on front store
  As a Buyer
  I want to start and complete alternative checkout from shopping list with wrong order confirmation template, email will not be sent

  Scenario: Feature Background
    Given sessions active:
      | Admin      | first_session  |
      | Buyer      | second_session |
      | FrontAdmin | system_session |
    And I activate "Alternative Checkout" workflow

  Scenario: Edit order confirmation template
    Given I proceed as the Admin
    And login as administrator
    And I go to System/ Emails/ Templates
    And I filter Template Name as Contains "order_confirmation_email"
    And I click edit "order_confirmation_email" in grid
    And I fill "Email Template Form" with:
      | Content | {{ item.product_name_with_error }} |
    When I save form
    Then I should see "Template saved" flash message

  Scenario: Create order
    Given I proceed as the Buyer
    And I signed in as MarleneSBradley@example.org on the store frontend
    When I open page with shopping list List Threshold
    And I click "Create Order"
    And I check "Ship to this address" on the checkout page
    And I select "Fifth avenue, 10115 Berlin, Germany" on the "Billing Information" checkout step and press Continue
    And I check "Flat Rate" on the "Shipping Method" checkout step and press Continue
    And I check "Payment Terms" on the "Payment" checkout step and press Continue
    And I check "Delete this shopping list after ordering" on the "Order Review" checkout step and press Request Approval
    Then I should see "You exceeded the allowable amount of $5000."

    When I click "Request Approval"
    Then I should see "Pending approval"

    And I proceed as the FrontAdmin
    When I signed in as NancyJSallee@example.org on the store frontend
    And I click "Account Dropdown"
    And I click "Order History"
    And I click "Check Out" on row "List Threshold" in grid
    And I click "Approve Order"

    And I proceed as the Buyer
    And reload the page
    Then I should see "Approved at"
    And I click "Submit Order"
    And I see the "Thank You" page with "Thank You For Your Purchase!" title
    And email with Subject "Your Store Name order has been received." was not sent
