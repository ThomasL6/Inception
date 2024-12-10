#!/bin/sh

echo "[WP config] Configuring WordPress..."

echo "[WP config] Waiting for MariaDB..."
while ! mariadb -h${DB_HOST} -u${WP_DB_USER} -p${WP_DB_PASS} ${WP_DB_NAME} &>/dev/null;
do
    sleep 3
done
echo "[WP config] MariaDB accessible."

WP_PATH=/var/www/html/wordpress

if [ -f ${WP_PATH}/wp-config.php ]
then
	echo "[WP config] WordPress already configured."
else
	echo "[WP config] Setting up WordPress..."
	echo "[WP config] Updating WP-CLI..."
	wp cli update --yes --allow-root
	echo "[WP config] Downloading WordPress..."
	wp core download --allow-root
	echo "[WP config] Creating wp-config.php..."
	wp config create --dbname=${WP_DB_NAME} --dbuser=${WP_DB_USER} --dbpass=${WP_DB_PASS} --dbhost=${DB_HOST} --path=${WP_PATH} --allow-root
	echo "[WP config] Installing WordPress core..."
	wp core install --url=${NGINX_HOST}/wordpress --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --path=${WP_PATH} --allow-root
	echo "[WP config] Creating WordPress default user..."
	wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASS} --role=subscriber --display_name=${WP_USER} --porcelain --path=${WP_PATH} --allow-root
	echo "[WP config] Installing WordPress theme..."
	wp theme install blocksy --path=${WP_PATH} --activate --allow-root
	wp theme status blocksy --allow-root
fi

echo "[WP config] Starting WordPress fastCGI on port 9000."
exec /usr/sbin/php-fpm83 -F -R
