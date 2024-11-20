@regression
@feature-BB-15731
@fixture-OroFlatRateShippingBundle:FlatRateIntegration.yml
@fixture-OroPaymentTermBundle:PaymentTermIntegration.yml
@fixture-OroProductBundle:gdpr_refactor.yml
@fixture-OroConsentBundle:ConsentLandingPagesFixture.yml
@fixture-OroAlternativeCheckoutBundle:AlternativeCheckout.yml
Feature: Alternative checkout with consents
  In order to accept consents on alternative checkout
  As an Frontend User
  I want to be able check consents and proceed checkout

  Scenario: Feature Background
    Given I activate "Alternative Checkout" workflow
    And sessions active:
      | Admin | first_session  |
      | User  | second_session |
    And I enable configuration options:
      | oro_consent.consent_feature_enabled |

  Scenario: Admin creates Landing Page and Content Node in Web Catalog
    Given I proceed as the Admin
    And I login as administrator
    And go to Marketing/ Web Catalogs
    And click "Create Web Catalog"
    And fill form with:
      | Name | Store and Process |
    When I click "Save and Close"
    Then I should see "Web Catalog has been saved" flash message
    And I click "Edit Content Tree"
    And I fill "Content Node Form" with:
      | Titles | Home page |
    And I click "Add System Page"
    When I save form
    Then I click "Create Content Node"
    And I click on "Show Variants Dropdown"
    And I click "Add Landing Page"
    And I fill "Content Node Form" with:
      | Titles       | Store and Process Node |
      | Url Slug     | store-and-process-node |
      | Landing Page | Consent Landing        |
    When I save form
    Then I should see "Content Node has been saved" flash message
    And I click "Create Content Node"
    And I click on "Show Variants Dropdown"
    And I click "Add Landing Page"
    And I fill "Content Node Form" with:
      | Titles       | Test Node     |
      | Url Slug     | test-node     |
      | Landing Page | Test CMS Page |
    When I save form
    Then I should see "Content Node has been saved" flash message
    And I set "Store and Process" as default web catalog

  Scenario: Admin creates consents (Mandatory without node assigned, mandatory and optional with node)
    Given I go to System/ Consent Management
    And click "Create Consent"
    And fill "Consent Form" with:
      | Name | Email Newsletters |
      | Type | Mandatory         |
    And I save and create new form
    And fill "Consent Form" with:
      | Name        | Collecting and storing personal data |
      | Type        | Mandatory                            |
      | Web Catalog | Store and Process                    |
    And I click "Store and Process Node"
    And I save and create new form
    And fill "Consent Form" with:
      | Name        | Receive notifications |
      | Type        | Optional              |
      | Web Catalog | Store and Process     |
    When I click "Store and Process Node"
    Then save and close form

  Scenario: Admin selects consents to be enabled on Frontstore
    Given go to System/ Configuration
    And follow "Commerce/Customer/Interactions" on configuration sidebar
    And I uncheck "Use default" for "Enabled user consents" field
    And click "Add Consent"
    And I choose Consent "Email Newsletters" in 1 row
    And click "Add Consent"
    And I choose Consent "Collecting and storing personal data" in 2 row
    And click "Add Consent"
    And I choose Consent "Receive notifications" in 3 row
    When click "Save settings"
    Then I should see "Configuration saved" flash message

  Scenario: Check mandatory consents on Checkout Page
    Given I proceed as the User
    And MarleneSBradley@example.org customer user has Buyer role
    And I signed in as MarleneSBradley@example.org on the store frontend
    And I open page with shopping list List Threshold
    When I click "Create Order"
    Then I should see "Agreements" in the "Checkout Step Title" element
    And I should see 2 elements "Required Consent"
    And the "Email Newsletters" checkbox should not be checked
    And the "Collecting and storing personal data" checkbox should not be checked
    And I should not see "Receive notifications"
    When I click "Continue"
    Then I should see that "Required Consent" contains "This agreement is required"
    And I click on "Consent Link" with title "Collecting and storing personal data"
    And I scroll modal window to bottom
    And click "Agree"
    When click "Continue"
    Then I should see that "Required Consent" contains "This agreement is required"
    And fill form with:
      | I Agree with Email Newsletters | true |
    And the "Email Newsletters" checkbox should be checked
    When click "Continue"
    Then I should see "Billing Information" in the "Checkout Step Title" element
    When on the "Billing Information" checkout step I go back to "Edit Agreements"
    Then I should see "Agreements" in the "Checkout Step Title" element
    And I should see "All mandatory consents were accepted."
    And I should not see "Email Newsletters"
    And I should not see "Collecting and storing personal data"

  Scenario: Add one more mandatory consent during checkout process
    Given I proceed as the Admin
    And I go to System/ Consent Management
    And click "Create Consent"
    And fill "Consent Form" with:
      | Name | Test Consent |
      | Type | Mandatory    |
    When save and close form
    Then I should see "Consent has been created" flash message
    And go to System/ Configuration
    And follow "Commerce/Customer/Interactions" on configuration sidebar
    And click "Add Consent"
    And I choose Consent "Test Consent" in 4 row
    When click "Save settings"
    Then I should see "Configuration saved" flash message

  Scenario: Check that redirect was executed and flash message is appeared on checkout
    Given I proceed as the User
    And I click "Continue"
    When I click "Continue"
    Then I should see "You have been redirected to the Agreements page as a new mandatory consent has been added and requires your attention. Please, review and accept it to proceed." flash message and I close it
    And I should see "Agreements" in the "Checkout Step Title" element
    And I should see 1 elements "Required Consent"
    And I should see "Test Consent"

  Scenario: Process checkout
    Given I fill form with:
      | Test Consent | true |
    And click "Continue"
    And I check "Ship to this address" on the checkout page
    And I select "Fifth avenue, 10115 Berlin, Germany" on the "Billing Information" checkout step and press Continue
    And I check "Flat Rate" on the "Shipping Method" checkout step and press Continue
    And I check "Payment Terms" on the "Payment" checkout step and press Continue
    When I check "Delete this shopping list after ordering" on the "Order Review" checkout step and press Request Approval
    Then I should see "You exceeded the allowable amount of $5000."
    When I click "Request Approval"
    Then I should see "Pending approval"

  Scenario: Check mandatory consents on Checkout Page for storefront Admin
    Given I proceed as the Admin
    And I click Logout in user menu
    And I signed in as NancyJSallee@example.org on the store frontend
    And I click "Account Dropdown"
    And click "Order History"
    When click "Check Out" on row "List Threshold" in grid
    Then I should see "Agreements" in the "Checkout Step Title" element
    And I should see 3 elements "Required Consent"
    And I should see "You have been redirected to the Agreements page as a new mandatory consent has been added and requires your attention. Please, review and accept it to proceed." flash message and I close it
    And the "Email Newsletters" checkbox should not be checked
    And the "Collecting and storing personal data" checkbox should not be checked
    And the "Test Consent" checkbox should not be checked
    And I should not see "Receive notifications"
    And I click on "Consent Link" with title "Collecting and storing personal data"
    And I scroll modal window to bottom
    And click "Agree"
    And fill form with:
      | I Agree with Email Newsletters | true |
      | Test Consent                   | true |
    And click "Continue"

  @skip
  Scenario: Approve Order
    #There is no possibility to approve an order because of BB-15929
    Given I click "Approve Order"

  @skip
  Scenario: Submit Order
    Given I proceed as the User
    When reload the page
    Then I should see "Approved at"
    When click "Submit Order"
    Then I see the "Thank You" page with "Thank You For Your Purchase!" title
