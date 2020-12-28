<?php
declare(strict_types=1);

namespace Oro\Bundle\AlternativeCheckoutBundle\Tests\Functional\DataFixtures;

use Doctrine\Persistence\ObjectManager;
use Oro\Bundle\CheckoutBundle\Tests\Functional\DataFixtures\LoadCheckoutSubtotals;

class LoadQuoteAlternativeCheckoutsSubtotalsData extends LoadCheckoutSubtotals
{
    public const ALTERNATIVE_CHECKOUT_SUBTOTAL_1 = 'alternative.checkout.subtotal.1';
    public const ALTERNATIVE_CHECKOUT_SUBTOTAL_2 = 'alternative.checkout.subtotal.2';

    /**
     * {@inheritdoc}
     */
    public function load(ObjectManager $manager): void
    {
        static::$data = array_merge(
            static::$data,
            [
                self::ALTERNATIVE_CHECKOUT_SUBTOTAL_1 => [
                    'checkout' => LoadQuoteAlternativeCheckoutsData::CHECKOUT_1,
                    'currency' => 'USD',
                    'amount' => 600,
                    'valid' => true,
                ],
                self::ALTERNATIVE_CHECKOUT_SUBTOTAL_2 => [
                    'checkout' => LoadQuoteAlternativeCheckoutsData::CHECKOUT_2,
                    'currency' => 'USD',
                    'amount' => 700,
                    'valid' => true,
                ],
            ]
        );

        parent::load($manager);
    }

    /**
     * {@inheritdoc}
     */
    public function getDependencies(): array
    {
        return array_merge(
            parent::getDependencies(),
            [
                LoadQuoteAlternativeCheckoutsData::class,
            ]
        );
    }
}
