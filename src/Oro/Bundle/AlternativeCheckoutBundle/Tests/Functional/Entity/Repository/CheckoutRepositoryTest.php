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
    private CheckoutRepository $repository;

    #[\Override]
    protected function setUp(): void
    {
        $this->initClient();
        $this->loadFixtures([
            LoadQuoteAlternativeCheckoutsData::class,
            BaseLoadQuoteCheckoutsData::class,
            LoadCustomerUserData::class
        ]);
        $this->repository = self::getContainer()->get('doctrine')->getRepository(Checkout::class);
    }

    /**
     * @dataProvider findCheckoutByCustomerUserAndSourceCriteriaByQuoteDemandProvider
     */
    public function testFindCheckoutByCustomerUserAndSourceCriteriaByQuoteDemand(
        string $checkout,
        string $workflowName
    ): void {
        $foundCheckout = $this->repository->findCheckoutByCustomerUserAndSourceCriteriaWithCurrency(
            $this->getReference(LoadCustomerUserData::EMAIL),
            ['quoteDemand' => $this->getReference(LoadQuoteProductDemandData::QUOTE_DEMAND_1)],
            $workflowName
        );
        self::assertSame($this->getReference($checkout), $foundCheckout);
    }

    public static function findCheckoutByCustomerUserAndSourceCriteriaByQuoteDemandProvider(): array
    {
        return [
            'checkout' => [
                BaseLoadQuoteCheckoutsData::CHECKOUT_1,
                'b2b_flow_checkout'
            ],
            'alternative checkout' => [
                LoadQuoteAlternativeCheckoutsData::CHECKOUT_1,
                'b2b_flow_alternative_checkout'
            ]
        ];
    }
}
