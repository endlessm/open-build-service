* * * * *       www-data    cd /srv/www/obs/api/ && RAILS_ENV=production rake -s jobs:workerstatus > /dev/null
# Disabled: it is apparently used for updating non existing obs bugzilla. SIN: #55
#1 * * * *       www-data    cd /srv/www/obs/api/ && RAILS_ENV=production rake -s jobs:updateissues > /dev/null
