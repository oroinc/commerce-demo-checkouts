<?php

declare(strict_types=1);

namespace Oro\Bundle\AlternativeCheckoutBundle\Tests\Unit\EventListener;

use Oro\Bundle\AlternativeCheckoutBundle\EventListener\QuantityToOrderConditionListener;
use Oro\Bundle\InventoryBundle\Tests\Unit\EventListener\QuantityToOrderConditionListenerTest as BaseTest;

class QuantityToOrderConditionListenerTest extends BaseTest
{
    /** @var string */
    protected const WORKFLOW_NAME = 'b2b_flow_alternative_checkout';

    protected function setUp(): void
    {
        parent::setUp();

        $this->quantityToOrderConditionListener = new QuantityToOrderConditionListener(
            $this->validatorService,
            $this->doctrineHelper
        );
    }
}
