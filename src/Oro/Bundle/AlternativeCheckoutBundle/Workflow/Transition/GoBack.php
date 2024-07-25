<?php

namespace Oro\Bundle\AlternativeCheckoutBundle\Workflow\Transition;

use Oro\Bundle\CheckoutBundle\Entity\Checkout;
use Oro\Bundle\CheckoutBundle\Workflow\ActionGroup\UpdateShippingPriceInterface;
use Oro\Bundle\WorkflowBundle\Entity\WorkflowItem;
use Oro\Bundle\WorkflowBundle\Model\TransitionServiceAbstract;

/**
 * AlternativeCheckout go_back transition logic implementation.
 */
class GoBack extends TransitionServiceAbstract
{
    public function __construct(
        private UpdateShippingPriceInterface $updateShippingPrice
    ) {
    }

    public function execute(WorkflowItem $workflowItem): void
    {
        /** @var Checkout $checkout */
        $checkout = $workflowItem->getEntity();
        $this->updateShippingPrice->execute($checkout);
        $workflowItem->getData()->offsetSet('allowed', false);
    }
}
