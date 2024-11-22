The upgrade instructions are available at [Oro documentation website](https://doc.oroinc.com/master/backend/setup/upgrade-to-new-version/).

The current file describes significant changes in the code that may affect the upgrade of your customizations.


## Changes in the Commerce-Demo-Checkouts package versions

### UNRELEASED

#### Changed

##### Alternative Checkout workflow

* Reworked an alternative checkout to contain only addition to the default multistep checkout, transition definitions were moved to services, import used to not copy-paste base workflow config (should simplify updates and receive all functionalities of base flow)
* Moved all alternative-checkout tests to demo checkouts bundle

### 6.0.0-RC (2024-02-29)

#### Removed
* Removed `Oro\Bundle\AlternativeCheckoutBundle\EventListener\QuantityToOrderConditionListener`,

### 4.2.0 (2020-01-29)

OroAlternativeCheckoutBundle has been moved from the `oro/commerce` package to the `oro/commerce-demo-checkouts` package.
