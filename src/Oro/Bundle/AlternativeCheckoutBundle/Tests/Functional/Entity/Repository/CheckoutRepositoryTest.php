<?php

declare(strict_types=1);

namespace Oro\Bundle\AlternativeCheckoutBundle\Tests\Functional\Entity\Repository;

use Oro\Bundle\AlternativeCheckoutBundle\Tests\Functional\DataFixtures\LoadQuoteAlternativeCheckoutsData;
use Oro\Bundle\CheckoutBundle\Entity\Checkout;
use Oro\Bundle\CheckoutBundle\Entity\Repository\CheckoutRepository;
use Oro\Bundle\CustomerBundle\Tests\Functional\DataFixtures\LoadCustomerUserData;
use Oro\Bundle\SaleBundle\Tests\Functional\DataFixtures\LoadQuoteCheckoutsData as BaseLoadQuoteCheckoutsData;
use Oro\Bundle\SaleBundle\Tests\Functional\DataFixtures\LoadQuoteProductDemandData;
use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

class CheckoutRepositoryTest extends WebTestCase
{
    #[\Override]
    protected function setUp(): void
    {
        $this->initClient();
        $this->loadFixtures(
            [
                LoadQuoteAlternativeCheckoutsData::class,
                BaseLoadQuoteCheckoutsData::class,
                LoadCustomerUserData::class,
            ]
        );
    }

    protected function getRepository(): CheckoutRepository
    {
        return $this->getContainer()->get('doctrine')->getRepository(Checkout::class);
    }

    /**
     * @param string $checkout
     * @param string $workflowName
     * @dataProvider findCheckoutByCustomerUserAndSourceCriteriaByQuoteDemandProvider
     */
    public function testFindCheckoutByCustomerUserAndSourceCriteriaByQuoteDemand($checkout, $workflowName): void
    {
        $customerUser = $this->getReference(LoadCustomerUserData::EMAIL);
        $criteria = ['quoteDemand' => $this->getReference(LoadQuoteProductDemandData::QUOTE_DEMAND_1)];

        $this->assertSame(
            $this->getReference($checkout),
            $this->getRepository()->findCheckoutByCustomerUserAndSourceCriteriaWithCurrency(
                $customerUser,
                $criteria,
                $workflowName
            )
        );
    }

    public function findCheckoutByCustomerUserAndSourceCriteriaByQuoteDemandProvider(): array
    {
        return [
            'checkout' => [
                BaseLoadQuoteCheckoutsData::CHECKOUT_1,
                'b2b_flow_checkout',
            ],
            'alternative checkout' => [
                LoadQuoteAlternativeCheckoutsData::CHECKOUT_1,
                'b2b_flow_alternative_checkout',
            ],
        ];
    }
}
