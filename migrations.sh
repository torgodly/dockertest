#!/bin/sh

# Wait for MySQL to be ready and accessible
max_tries=30
count=0
echo "Waiting for MySQL to be ready..."

# Try to connect and show any errors for debugging
mysql -h mysql -u root -p'9qpsz2pvkf5dh11k' -e "SELECT 1" 2>&1 || echo "Initial connection test failed"

while ! mysql -h mysql -u root -p'9qpsz2pvkf5dh11k' -e "SELECT 1" >/dev/null 2>&1; do
    sleep 5
    count=$((count+1))
    if [ $count -gt $max_tries ]; then
        echo "Error: MySQL did not become ready in time"
        echo "Trying one last time with debug info:"
        mysql -h mysql -u root -p'9qpsz2pvkf5dh11k' -e "SELECT 1"
        exit 1
    fi
    echo "Still waiting for MySQL... ($count/$max_tries)"
done

echo "MySQL is ready, running migrations..."

# Run migrations and seeds
php artisan migrate --force && php artisan db:seed --force