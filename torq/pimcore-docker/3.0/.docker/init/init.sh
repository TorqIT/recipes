#!/usr/bin/env bash

set -e

# TODO use doctrine:sql for database check
if [ "$(mysql -h "$DATABASE_HOST" -u "$DATABASE_USER" -p"$DATABASE_PASSWORD" \
      -sse "select count(*) from information_schema.tables where table_schema='pimcore' and table_name='assets';")" -eq 0 ] \
   && [ "$PIMCORE_INSTALL" = "true" ]
then
  echo "Database is empty and PIMCORE_INSTALL is set to true, so calling pimcore-install..."
  runuser -u www-data -- vendor/bin/pimcore-install --skip-database-config --no-interaction
fi

# TODO install bundles using dynamic logic
echo Installing bundles...
runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:install PimcoreAdminBundle
runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:install PimcoreApplicationLoggerBundle
runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:install PimcoreCustomReportsBundle
runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:install PimcoreGlossaryBundle
runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:install PimcoreSeoBundle
runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:install PimcoreSimpleBackendSearchBundle
runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:install PimcoreStaticRoutesBundle
runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:install PimcoreTinymceBundle
runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:install PimcoreUuidBundle
runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:install PimcoreXliffBundle
runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:install PimcoreWordExportBundle

echo Running migration...
runuser -u www-data -- /var/www/html/bin/console doctrine:migrations:migrate -n

echo Rebuilding classes...
runuser -u www-data -- /var/www/html/bin/console pimcore:deployment:classes-rebuild -c -d -n --force

echo Creating folders...
runuser -u www-data -- /var/www/html/bin/console torq:folder-creator

echo Generating roles...
runuser -u www-data -- /var/www/html/bin/console torq:generate-roles

echo Generating quantity values...
runuser -u www-data -- /var/www/html/bin/console definition:import:units config/quantityvalues.json --override