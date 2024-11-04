<?php

declare(strict_types=1);

namespace Oro\Bundle\AlternativeCheckoutBundle\Condition;

use Oro\Bundle\CheckoutBundle\DataProvider\Manager\CheckoutLineItemsManager;
use Oro\Bundle\OrderBundle\Entity\Order;
use Oro\Bundle\PricingBundle\SubtotalProcessor\TotalProcessorProvider;
use Oro\Component\ConfigExpression\Condition\AbstractComparison;

/**
 * Checks that order with subtotal exceeding the specified value.
 *
 * Usage:
 * '@less_order_total_limit':
 *      - $checkout # any instance of the Checkout entity
 *      - 5000      # the value of the order approval threshold
 */
class OrderTotalLimit extends AbstractComparison
{
    private TotalProcessorProvider $totalsProvider;
    private CheckoutLineItemsManager $checkoutLineItemsManager;

    public function __construct(
        TotalProcessorProvider $totalsProvider,
        CheckoutLineItemsManager $checkoutLineItemsManager
    ) {
        $this->totalsProvider = $totalsProvider;
        $this->checkoutLineItemsManager = $checkoutLineItemsManager;
    }

    #[\Override]
    public function getName(): string
    {
        return 'less_order_total_limit';
    }

    #[\Override]
    protected function isConditionAllowed($context): bool
    {
        return $this->doCompare(
            $this->resolveValue($context, $this->left),
            $this->resolveValue($context, $this->right)
        );
    }

    #[\Override]
    protected function doCompare($left, $right): bool
    {
        $orderLineItems = $this->checkoutLineItemsManager->getData($left);
        $order = new Order();
        $order->setLineItems($orderLineItems);

        $orderTotalAmount = $this->totalsProvider->enableRecalculation()->getTotal($order)->getAmount();

        return $orderTotalAmount <= $right;
    }
}
