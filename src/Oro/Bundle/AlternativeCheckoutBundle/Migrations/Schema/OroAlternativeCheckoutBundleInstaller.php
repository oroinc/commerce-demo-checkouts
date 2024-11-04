<?php

declare(strict_types=1);

namespace Oro\Bundle\AlternativeCheckoutBundle\Migrations\Schema;

use Doctrine\DBAL\Schema\Schema;
use Oro\Bundle\MigrationBundle\Migration\Installation;
use Oro\Bundle\MigrationBundle\Migration\QueryBag;

class OroAlternativeCheckoutBundleInstaller implements Installation
{
    #[\Override]
    public function getMigrationVersion(): string
    {
        return 'v1_4';
    }

    #[\Override]
    public function up(Schema $schema, QueryBag $queries): void
    {
    }
}
