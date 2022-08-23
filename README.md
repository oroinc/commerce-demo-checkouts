OroCommerce Checkout Customization Examples
===========================================

This package includes examples of OroCommerce storefront checkout customizations.

OroAlternativeCheckoutBundle
----------------------------

OroAlternativeCheckoutBundle adds review and approval steps to the checkout workflow in the OroCommerce storefront if the order amount exceeds the order approval threshold value set by an application administrator in the alternative checkout workflow configuration UI.

Installation
------------

This package can be added to an existing installation of an OroCommerce application.

Use composer to add the package code:

```
composer require oro/commerce-demo-checkouts
```

Perform the installation:

```
php bin/console oro:platform:update --env=prod

```
Load the new workflow in database & the translations
```
php bin/console oro:workflow:definition:load --env=prod
php bin/console oro:translation:load --env=prod

```
