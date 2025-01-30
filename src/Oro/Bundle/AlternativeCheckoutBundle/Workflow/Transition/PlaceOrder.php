<?php

namespace Oro\Bundle\AlternativeCheckoutBundle\Workflow\Transition;

use Doctrine\Common\Collections\Collection;
use Oro\Bundle\ActionBundle\Model\ActionExecutor;
use Oro\Bundle\CheckoutBundle\Entity\Checkout;
use Oro\Bundle\WorkflowBundle\Entity\WorkflowItem;
use Oro\Bundle\WorkflowBundle\Model\TransitionServiceInterface;

/**
 * AlternativeCheckout place_order transition logic implementation.
 */
class PlaceOrder implements TransitionServiceInterface
{
    public function __construct(
        private TransitionServiceInterface $basePlaceOrder,
        private ActionExecutor $actionExecutor
    ) {
    }

    #[\Override]
    public function isPreConditionAllowed(WorkflowItem $workflowItem, ?Collection $errors = null): bool
    {
        /** @var Checkout $checkout */
        $checkout = $workflowItem->getEntity();
        $data = $workflowItem->getData();

        $lessOrderTotalLimit = $this->actionExecutor->evaluateExpression(
            'less_order_total_limit',
            [$checkout, $data->offsetGet('order_approval_threshold')],
            $errors
        );
        $aclGranted = $this->actionExecutor->evaluateExpression(
            'acl_granted',
            ['oro_alternativecheckout_checkout_approve'],
            $errors
        );
        $allowed = $data->offsetGet('allowed');
        if (!($lessOrderTotalLimit || $aclGranted || $allowed)) {
            $errors?->add(['message' => 'Pending approval']);

            return false;
        }

        if (!$this->basePlaceOrder->isPreConditionAllowed($workflowItem, $errors)) {
            return false;
        }

        return true;
    }

    #[\Override]
    public function isConditionAllowed(WorkflowItem $workflowItem, ?Collection $errors = null): bool
    {
        if (!$this->basePlaceOrder->isPreConditionAllowed($workflowItem, $errors)) {
            return false;
        }

        return true;
    }

    #[\Override]
    public function execute(WorkflowItem $workflowItem): void
    {
        $this->basePlaceOrder->execute($workflowItem);
    }
}
