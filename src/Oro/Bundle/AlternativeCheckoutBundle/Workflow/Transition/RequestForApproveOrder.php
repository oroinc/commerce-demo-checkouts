<?php

namespace Oro\Bundle\AlternativeCheckoutBundle\Workflow\Transition;

use Doctrine\Common\Collections\Collection;
use Oro\Bundle\ActionBundle\Model\ActionExecutor;
use Oro\Bundle\CheckoutBundle\Entity\Checkout;
use Oro\Bundle\WorkflowBundle\Entity\WorkflowItem;
use Oro\Bundle\WorkflowBundle\Model\TransitionServiceAbstract;

class RequestForApproveOrder extends TransitionServiceAbstract
{
    public function __construct(
        private ActionExecutor $actionExecutor
    ) {
    }

    public function isConditionAllowed(WorkflowItem $workflowItem, Collection $errors = null): bool
    {
        /** @var Checkout $checkout */
        $checkout = $workflowItem->getEntity();

        $quoteAcceptable = $this->actionExecutor->evaluateExpression(
            'quote_acceptable',
            [$checkout->getSourceEntity(), true],
            $errors
        );
        if (!$quoteAcceptable) {
            return false;
        }

        return true;
    }

    public function execute(WorkflowItem $workflowItem): void
    {
        $data = $workflowItem->getData();
        if (!$data->offsetGet('requested_for_approve')) {
            $data->offsetSet('requested_for_approve', true);
        }
    }
}
