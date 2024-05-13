@regression
@ticket-BB-9598
@fixture-OroCheckoutBundle:ReOrder/BaseIntegrationsFixture.yml
@fixture-OroCheckoutBundle:AdditionalIntegrations.yml
@fixture-OroCheckoutBundle:ReOrder/AlternativeCustomerUserFixture.yml
@fixture-OroCheckoutBundle:ReOrder/CustomerUserAddressFixture.yml
@fixture-OroCheckoutBundle:ReOrder/ProductFixture.yml
@fixture-OroCheckoutBundle:ReOrder/OrderFixture.yml
@fixture-OroCheckoutBundle:ReOrder/PaymentTransactionFixture.yml
@fixture-OroWarehouseBundle:ReOrder/InventoryLevelFixture.yml

Feature: Re-order using Alternative Checkout workflow
  In order to quickly re-order the items I've ordered before
  As a Customer User
  I want to be able to start new checkout using the items from an existing order

  Scenario: Create different window session
    Given sessions active:
      | Admin | first_session  |
      | Buyer | second_session |

  Scenario: Enable Alternative Checkout Workflow
    Given I proceed as the Admin
    And I login as administrator
    And I go to System/Workflows
    When I click "Activate" on row "Alternative Checkout" in grid
    And I click "Activate" in modal window
    Then I should see "Workflow activated" flash message

  Scenario: Enable warehouses
    Given I go to System / Configuration
    And I follow "Commerce/Inventory/Warehouses" on configuration sidebar
    When I fill "Warehouses Option Form" with:
      | Enabled Warehouses | Main Warehouse |
    And I click "Save settings"
    Then I should see "Configuration saved" flash message
    And I follow "Commerce/Inventory/Product Option" on configuration sidebar
    And I fill "Product Option Form" with:
      | Manage Inventory Default | false |
      | Manage Inventory         | Yes   |
    And I click "Save settings"
    Then I should see "Configuration saved" flash message

  Scenario: Create order from Shopping list
    Given I proceed as the Buyer
    And I login as AmandaRCole@example.org buyer
    When I open page with shopping list List 1
    And I click "Create Order"
    And I click "Continue"
    And I click "Continue"
    And I click "Continue"
    And I click "Continue"
    And I click "Submit Order"
    Then I should see "Thank You For Your Purchase!"

  Scenario: Unable to create order from exist Order without available products
    And I click "Account Dropdown"
    When I click "Order History"
    And I click "Re-Order" on row "SecondOrder" in grid "Past Orders Grid"
    Then I should see "The re-order cannot be processed as all the products are currently unavailable." flash message
    And click on "Flash Message Close Button"

  Scenario: Create order from exist Order
    And I click "Account Dropdown"
    When I click "Order History"
    And I click "Re-Order" on row "FirstOrder" in grid "Past Orders Grid"
    Then I should see "Please note that the current order differs from the original one due to the absence or insufficient quantity in stock of the following products: BBB2, CCC3, DDD4." flash message
    When I click "Continue"
    And I click "Continue"
    And I click "Continue"
    And I click "Continue"
    And I click "Submit Order"
    Then I should see "Thank You For Your Purchase!"

  Scenario: Check created orders
    Given I proceed as the Admin
    When I go to Sales / Orders
    Then I should see following grid:
      | Order Number | Total     | Payment Method   | Shipping Method | Payment Term |
      | 4            | $3,459.00 | Payment Term Two | Flat Rate Two   | net 90       |
      | 3            | $3,568.00 | Payment Term One | Flat Rate One   | net 10       |
      | SecondOrder  | $30.00    | Payment Term Two | Flat Rate Two   | net 90       |
      | FirstOrder   | $2,121.00 | Payment Term Two | Flat Rate Two   | net 90       |

    When I click View $3,568.00 in grid
    Then I should see Order with:
      | Order Number     | 3                      |
      | Source Document  | Shopping List "List 1" |
      | Payment Method   | Payment Term One       |
      | Billing Address  | Address 1              |
      | Shipping Address | Address 1              |
      | Payment Term     | net 10                 |
      | Shipping Method  | Flat Rate One          |
      | Shipping Cost    | $3.00                  |
    And I should see "HAINES CITY FL US 33844"
    And I should not see "Address 3"
    And I should not see "ROMNEY IN US 47981"
    And I should not see "Address 2"
    And I should not see "ROCHESTER NY US 14609"
    And I should not see "Flat Rate Two"
    And I should not see "Payment Term Two"
    And number of records in "Backend Order Line Items Grid" should be 2
    And I should see following "Backend Order Line Items Grid" grid:
      | SKU  | Product  | Quantity | Product Unit Code | Price   |
      | AAA1 | Product1 | 15       | piece             | $201.00 |
      | BBB2 | Product2 | 25       | item              | $22.00  |

    When I go to Sales / Orders
    And I click View $3,459.00 in grid
    Then I should see Order with:
      | Order Number     | 4                  |
      | Source Document  | Order "FirstOrder" |
      | Payment Method   | Payment Term Two   |
      | Billing Address  | Address 3          |
      | Shipping Address | Address 2          |
      | Payment Term     | net 90             |
      | Shipping Method  | Flat Rate Two      |
      | Shipping Cost    | $4.00              |
    And I should see "ROMNEY IN US 47981"
    And I should see "ROCHESTER NY US 14609"
    And I should not see "Address 1"
    And I should not see "HAINES CITY FL US 33844"
    And I should not see "Flat Rate One"
    And I should not see "Payment Term One"
    And number of records in "Backend Order Line Items Grid" should be 2
    And I should see following "Backend Order Line Items Grid" grid:
      | SKU  | Product  | Quantity | Product Unit Code | Price   |
      | AAA1 | Product1 | 15       | piece             | $201.00 |
      | BBB2 | Product2 | 20       | item              | $22.00  |
