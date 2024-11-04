@regression
@fix-BB-14261
@fixture-OroFlatRateShippingBundle:FlatRateIntegration.yml
@fixture-OroPaymentTermBundle:PaymentTermIntegration.yml
@fixture-OroConsentBundle:ConsentLandingPagesFixture.yml
@fixture-OroAlternativeCheckoutBundle:AlternativeCheckout.yml
Feature: Alternative Checkout with removed consents
  In order to accept consents on Alternative Checkout
  As an Storefront User
  I want to be able check consents and proceed checkout

  Scenario: Feature Background
    Given sessions active:
      | Admin | first_session  |
      | User  | second_session |
    And I enable configuration options:
      | oro_consent.consent_feature_enabled |

  Scenario: Admin creates Landing Page and Content Node in Web Catalog
    Given I proceed as the Admin
    And login as administrator
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
    And I set "Store and Process" as default web catalog

  Scenario: Admin creates consents
    Given I go to System/ Consent Management
    And click "Create Consent"
    And fill "Consent Form" with:
      | Name | Email Newsletters |
      | Type | Mandatory         |
    And I click "Store and Process Node"
    And I save and create new form
    And fill "Consent Form" with:
      | Name | Receive notifications |
      | Type | Optional              |
    And save and close form

  Scenario: Admin selects consents to be enabled on Storefront
    Given I go to System/ Configuration
    And follow "Commerce/Customer/Interactions" on configuration sidebar
    And I uncheck "Use default" for "Enabled user consents" field
    And click "Add Consent"
    And I choose Consent "Email Newsletters" in 1 row
    And click "Add Consent"
    And I choose Consent "Receive notifications" in 2 row
    When click "Save settings"
    Then I should see "Configuration saved" flash message

  Scenario: Logged User starts Alternative Checkout
    Given I proceed as the User
    And MarleneSBradley@example.org customer user has Buyer role
    And I signed in as MarleneSBradley@example.org on the store frontend
    And I open page with shopping list List Threshold
    And I scroll to top
    When I click "Create Order"
    Then I should see "Agreements" in the "Checkout Step Title" element
    And I should see 1 element "Required Consent"

  Scenario: Admin remove required consent
    Given I proceed as the Admin
    And I go to System/ Consent Management
    When I click delete "Email Newsletters" in grid
    Then I should see "Are you sure you want to delete this consent?"
    When I click "Yes, Delete"
    Then I should not see "Email Newsletters"

  Scenario: Logged User proceed Alternative Checkout
    Given I proceed as the User
    And I click "Email Newsletters"
    And I scroll modal window to bottom
    And click "Agree"
    When click "Continue"
    Then I should see "Some consents were changed. Please reload the page."
    And I should not see "Email Newsletters"
    When I reload the page
    And click "Continue"
    Then I should see "Billing Information" in the "Checkout Step Title" element
