The upgrade instructions are available at [Oro documentation website](https://doc.oroinc.com/master/backend/setup/upgrade-to-new-version/).

The current file describes significant changes in the code that may affect the upgrade of your customizations.

## Changes in the Сommerce-Demo-Checkouts package versions

### UNRELEASED

#### Removed
* Deprecated `Oro\Bundle\AlternativeCheckoutBundle\EventListener\QuantityToOrderConditionListener`. Will be moved to the validation.yml config instead.

### 4.2.0 (2020-01-29)

OroAlternativeCheckoutBundle has been moved from the `oro/commerce` package to the `oro/commerce-demo-checkouts` package.
