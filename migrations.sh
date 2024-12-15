#!/bin/sh

# Wait for MySQL to be ready and accessible
max_tries=30
count=0
echo "Waiting for MySQL to be ready..."
while ! mysql -h mysql -u root -p'j7kxu7cjo93b24ke' -e "SELECT 1" >/dev/null 2>&1; do
    sleep 2
    count=$((count+1))
    if [ $count -gt $max_tries ]; then
        echo "Error: MySQL did not become ready in time"
        exit 1
    fi
    echo "Still waiting for MySQL... ($count/$max_tries)"
done

# Wait a bit more to ensure user creation is complete
sleep 5

# Run migrations and seeds
php artisan migrate --force && php artisan db:seed --force