@regression
@ticket-BB-12063
@fixture-OroFlatRateShippingBundle:FlatRateIntegration.yml
@fixture-OroPaymentTermBundle:PaymentTermIntegration.yml
@fixture-OroWarehouseBundle:AlternativeCheckout.yml
@fixture-OroWarehouseBundle:Checkout.yml
Feature: Alternative Checkout workflow threshold
  In order to create order on front store
  As a buyer
  I want to start and request approval of alternative checkout

  Scenario: Create different window session
    Given sessions active:
      | User  | first_session  |
      | Admin | second_session |

  Scenario: Activate Alternative Checkout workflow
    Given I proceed as the Admin
    And I login as administrator
    When I go to System/ Workflows
    And I click Activate Alternative Checkout in grid
    And I click "Activate" in modal window
    Then I should see "Workflow activated" flash message

  Scenario: Start checkout with Alternative Checkout with threshold
    Given I proceed as the User
    And There is EUR currency in the system configuration
    And I enable the existing warehouses
    And MarleneSBradley@example.org customer user has Buyer role
    And I signed in as MarleneSBradley@example.org on the store frontend
    When I open page with shopping list List Threshold
    And I click "Create Order"
    And I select "Fifth avenue, 10115 Berlin, Germany" on the "Billing Information" checkout step and press Continue
    And I select "Fifth avenue, 10115 Berlin, Germany" on the "Shipping Information" checkout step and press Continue
    And I check "Flat Rate" on the "Shipping Method" checkout step and press Continue
    And I check "Payment Terms" on the "Payment" checkout step and press Continue
    And I fill "Checkout Order Review Form" with:
      | PO Number              | TEST_PO_NUMBER     |
      | Notes                  | Customer test note |
      | Do not ship later than | 7/1/2018           |
    And I click on empty space
    And I check "Delete this shopping list after submitting order" on the "Order Review" checkout step and press Request Approval
    Then I should see "You exceeded the allowable amount of $5000."
    When I click "Request Approval"
    Then I should see "Pending approval"

  Scenario: Approve checkout and create order
    Given I signed in as NancyJSallee@example.org on the store frontend
    And I click "Account Dropdown"
    And click "Order History"
    And click "Check Out" on row "List Threshold" in grid
    And click "Approve Order"
    And I proceed as the User
    And reload the page
    Then I should see "Approved at"
    And click "Submit Order"
    And I see the "Thank You" page with "Thank You For Your Purchase!" title
    And Email should contains the following:
      | Body | PO Number TEST_PO_NUMBER |
      | Body | Ship by 7/1/2018         |
      | Body | Notes Customer test note |

  Scenario: Check created order
    Given I proceed as the Admin
    When I go to Sales/ Orders
    And I filter PO Number as is equal to "TEST_PO_NUMBER"
    And click View TEST_PO_NUMBER in grid
    Then I should see Quote with:
      | PO Number              | TEST_PO_NUMBER     |
      | Do Not Ship Later Than | Jul 1, 2018        |
      | Customer Notes         | Customer test note |
