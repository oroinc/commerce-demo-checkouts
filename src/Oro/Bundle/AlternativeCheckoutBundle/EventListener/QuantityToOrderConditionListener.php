<?php

declare(strict_types=1);

namespace Oro\Bundle\AlternativeCheckoutBundle\EventListener;

use Oro\Bundle\InventoryBundle\EventListener\QuantityToOrderConditionListener as BaseListener;

/**
 * Handles line items inventory validation events of the alternative checkout workflow.
 */
class QuantityToOrderConditionListener extends BaseListener
{
    /** @var array */
    protected const ALLOWED_WORKFLOWS = [
        'b2b_flow_alternative_checkout',
    ];
}
