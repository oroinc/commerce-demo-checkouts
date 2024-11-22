<?php

namespace Oro\Bundle\AlternativeCheckoutBundle\Workflow\Transition;

use Doctrine\Common\Collections\Collection;
use Oro\Bundle\ActionBundle\Model\ActionExecutor;
use Oro\Bundle\CheckoutBundle\Entity\Checkout;
use Oro\Bundle\WorkflowBundle\Entity\WorkflowItem;
use Oro\Bundle\WorkflowBundle\Model\TransitionServiceAbstract;

/**
 * AlternativeCheckout continue_to_request_approval transition logic implementation.
 */
class ContinueToRequestApproval extends TransitionServiceAbstract
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

        $lessOrderTotalLimit = $this->actionExecutor->evaluateExpression(
            'less_order_total_limit',
            [$checkout, $data->offsetGet('order_approval_threshold')],
            $errors
        );
        if ($lessOrderTotalLimit) {
            return false;
        }

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

        // Do not request approval customer users with Checkout Approve permission
        $aclGranted = $this->actionExecutor->evaluateExpression(
            'acl_granted',
            ['oro_alternativecheckout_checkout_approve'],
            $errors
        );
        if ($aclGranted) {
            return false;
        }

        return true;
    }
}
