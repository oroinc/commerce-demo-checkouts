<?php

namespace Oro\Bundle\AlternativeCheckoutBundle\Workflow\Transition;

use Doctrine\Common\Collections\Collection;
use Oro\Bundle\ActionBundle\Model\ActionExecutor;
use Oro\Bundle\CheckoutBundle\Entity\Checkout;
use Oro\Bundle\WorkflowBundle\Entity\WorkflowItem;
use Oro\Bundle\WorkflowBundle\Model\TransitionServiceAbstract;

class ApproveOrder extends TransitionServiceAbstract
{
    public function __construct(
        private ActionExecutor $actionExecutor
    ) {
    }

    public function isPreConditionAllowed(WorkflowItem $workflowItem, Collection $errors = null): bool
    {
        /** @var Checkout $checkout */
        $checkout = $workflowItem->getEntity();
        $data = $workflowItem->getData();

        if ($data->offsetGet('allowed')) {
            return false;
        }

        $quoteAcceptable = $this->actionExecutor->evaluateExpression(
            'quote_acceptable',
            [$checkout->getSourceEntity(), true],
            $errors
        );
        if (!$quoteAcceptable) {
            return false;
        }

        $aclGranted = $this->actionExecutor->evaluateExpression(
            'acl_granted',
            ['oro_alternativecheckout_checkout_approve'],
            $errors
        );
        if (!$aclGranted) {
            return false;
        }

        return true;
    }

    public function execute(WorkflowItem $workflowItem): void
    {
        $data = $workflowItem->getData();

        $data->offsetSet('allowed', true);
        $data->offsetSet('allow_request_date', new \DateTime('now', new \DateTimeZone('UTC')));
    }
}
