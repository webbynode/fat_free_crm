sudo gem install rails --version=2.2.2 --no-rdoc --no-ri
sudo gem install -v 1.9.0 liquid
sudo gem install tzinfo test-unit 
sudo gem install rubyzip

echo WC_DB_ENGINE=${WC_DB_ENGINE}

echo "
login: &login
  adapter: ${WC_DB_ENGINE}
  database: ${WC_APP_NAME}
  username: ${WC_APP_NAME}
  password: ${WC_DB_PASSWORD}
  host: localhost
" > config/database.yml

if [ "${WC_DB_ENGINE}" == "mysql" ]; then
echo "
production:
  <<: *login
  encoding: utf8
" >> config/database.yml

    echo "GRANT SUPER ON *.* TO ${WC_APP_NAME}@localhost;" | mysql -u root -p${WC_DB_PASSWORD}
fi

if [ "${WC_DB_ENGINE}" == "postgresql" ]; then
echo "
production:
  <<: *login
  encoding: unicode
  pool: 5
  port: 5432
" >> config/database.yml
fi

RAILS_ENV=production rake db:create
RAILS_ENV=production rake crm:setup

chown -R www-data *

