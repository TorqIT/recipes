#!/bin/bash

echo "Installing Pimcore bundles..."

BUNDLES="$(
   runuser -u www-data -- /var/www/html/bin/console pimcore:bundle:list --ignore-maintenance-mode --json --no-debug --env=prod | 
  jq --raw-output '
    [
      .[]
      | select(
        .Enabled == true
        and .Installed == false
        and .Installable == true
      )
      | .Bundle
    ]
    | join(" ")
  '
)"

if [ -z "${BUNDLES}" ]; then
    echo "No bundles to install!"
    exit;
fi

for BUNDLE in ${BUNDLES}; do
   /var/www/html/bin/console pimcore:bundle:install "${BUNDLE}" --ignore-maintenance-mode --no-interaction --no-post-change-commands
done