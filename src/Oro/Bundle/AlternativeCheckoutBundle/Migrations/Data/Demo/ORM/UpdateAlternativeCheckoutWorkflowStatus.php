<?php

declare(strict_types=1);

namespace Oro\Bundle\AlternativeCheckoutBundle\Migrations\Data\Demo\ORM;

use Doctrine\Common\DataFixtures\AbstractFixture;
use Doctrine\Common\DataFixtures\DependentFixtureInterface;
use Doctrine\Persistence\ObjectManager;
use Oro\Bundle\CustomerBundle\Migrations\Data\Demo\ORM\LoadCustomerDemoData;
use Oro\Bundle\WorkflowBundle\Entity\WorkflowDefinition;
use Symfony\Component\DependencyInjection\ContainerAwareInterface;
use Symfony\Component\DependencyInjection\ContainerAwareTrait;

/**
 * Activates the alternative checkout workflow.
 */
class UpdateAlternativeCheckoutWorkflowStatus extends AbstractFixture implements
    DependentFixtureInterface,
    ContainerAwareInterface
{
    use ContainerAwareTrait;

    /**
     * {@inheritDoc}
     */
    public function getDependencies(): array
    {
        return [LoadCustomerDemoData::class];
    }

    /**
     * {@inheritDoc}
     */
    public function load(ObjectManager $manager): void
    {
        /** @var WorkflowDefinition $workflowDefinition */
        $workflowDefinition = $manager->getRepository(WorkflowDefinition::class)
            ->find('b2b_flow_alternative_checkout');
        if (!$workflowDefinition) {
            return;
        }

        $this->container->get('oro_workflow.manager.system')
            ->activateWorkflow($workflowDefinition->getName());
    }
}
