<?php

declare(strict_types=1);

namespace Oro\Bundle\AlternativeCheckoutBundle\Tests\Functional\Controller;

use Oro\Bundle\AlternativeCheckoutBundle\Tests\Functional\DataFixtures\LoadTranslations;
use Oro\Bundle\CheckoutBundle\Tests\Functional\Controller\WorkflowDefinitionCheckoutTestCase as BaseTest;

class WorkflowDefinitionControllerTest extends BaseTest
{
    protected function setUp(): void
    {
        parent::setUp();
        $this->loadFixtures([LoadTranslations::class]);
    }

    public function testCheckoutWorkflowViewPage(): void
    {
        $this->assertCheckoutWorkflowCorrectViewPage(
            'b2b_flow_alternative_checkout',
            'Alternative Checkout',
            'b2b_checkout_flow'
        );
    }
}
