@ticket-BB-10918
@ticket-BB-11388
@fixture-OroFlatRateShippingBundle:FlatRateIntegration.yml
@fixture-OroPaymentTermBundle:PaymentTermIntegration.yml
@fixture-OroAlternativeCheckoutBundle:AlternativeCheckout.yml

Feature: Alternative Checkout With Ship To Billing Address (EE)
  In order to create order on front store
  As a buyer
  I want to start and complete alternative checkout and use Billing Address as Shipping

  Scenario: Activate Alternative Checkout
    Given I login as administrator
    When I go to System/ Workflows
    And I click Activate Alternative Checkout in grid
    And I click "Activate" in modal window
    Then I should see "Workflow activated" flash message

  Scenario: Create different window sessions
    Given sessions active:
      | Frontend Buyer | first_session  |
      | Frontend Admin | second_session |

  Scenario: Create order
    Given I proceed as the Frontend Buyer
    And MarleneSBradley@example.org customer user has Buyer role
    And I signed in as MarleneSBradley@example.org on the store frontend
    When I open page with shopping list List Threshold
    And I click "Create Order"
    And I check "Ship to this address" on the checkout page
    And I select "Fifth avenue, 10115 Berlin, Germany" on the "Billing Information" checkout step and press Continue
    And I click on "Edit Billing Information"
    And I click "Add Address"
    And I fill "New Address Popup Form" with:
      | Label        | Billing address 1 |
      | Organization | ORO               |
      | Street       | Billing street 1  |
      | City         | Hamburg           |
      | Country      | Germany           |
      | State        | Hamburg           |
      | Postal Code  | 10115             |
    And I click "Continue" in modal window
    # TODO remove next line after backend fix
    And I click "Continue"
    And I click "Continue"
    And I check "Flat Rate" on the "Shipping Method" checkout step and press Continue
    And I check "Payment Terms" on the "Payment" checkout step and press Continue
    And I check "Delete this shopping list after submitting order" on the "Order Review" checkout step and press Request Approval
    Then I should see "You exceeded the allowable amount of $5000."
    When I click "Request Approval"
    Then I should see "Pending approval"

    And I proceed as the Frontend Admin
    When I signed in as NancyJSallee@example.org on the store frontend
    And I click "Account Dropdown"
    And I click "Order History"
    And I click "Check Out" on row "List Threshold" in grid
    And I click "Approve Order"

    And I proceed as the Frontend Buyer
    And reload the page
    Then I should see "Approved at"
    And I click "Submit Order"
    And I see the "Thank You" page with "Thank You For Your Purchase!" title

    When I follow "click here to review"
    Then I should be on Order Frontend View page
    And I should see Order with data:
      | Billing Address  | Billing address 1 ORO Billing street 1 10115 Hamburg Germany |
      | Shipping Address | Billing address 1 ORO Billing street 1 10115 Hamburg Germany |
      | Shipping Method  | Flat Rate                                                    |
      | Payment Method   | Payment Term                                                 |
