#!/bin/sh

# Wait for MySQL to be ready
while ! mysqladmin ping -h mysql -u root -p'$DB_PASSWORD' --silent; do
    echo "Waiting for database connection..."
    sleep 2
done

# Run migrations and seeds
php artisan db:seed --force

# Start the application
/init && php-fpm -D && nginx -g "daemon off;"
