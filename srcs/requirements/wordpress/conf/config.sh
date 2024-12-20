#!/bin/bash

sleep 15

if test ! -f /var/www/wordpress/wp-config.php; then
    mv /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
fi

# Configuring WordPress
wp config set --allow-root --add --path='/var/www/wordpress' DB_NAME $SQL_DATABASE
wp config set --allow-root --add --path='/var/www/wordpress' DB_USER $SQL_USER
wp config set --allow-root --add --path='/var/www/wordpress' DB_PASSWORD $SQL_PASSWORD
wp config set --allow-root --add --path='/var/www/wordpress' DB_HOST mariadb:3306

# Installing WordPress Core
wp core install \
    --allow-root \
    --path='/var/www/wordpress' \
    --url=https://thlefebv.42.fr \
    --title="La Confrerie" \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL}

# Creating a new user
wp user create \
    --allow-root \
    --path='/var/www/wordpress' \
    ${WP_USER} \
    ${WP_EMAIL} \
    --user_pass=${WP_PASSWORD}

# Variables for content
TITLE="Deviens un Male Alpha"
CONTENT=$(cat <<EOF
<!DOCTYPE html><html><head><style>* { margin: 0; padding: 0; box-sizing: border-box; } body { background-color: #ffffff; color: #000000; font-family: Arial, sans-serif; } .content-wrapper { padding: 20px; } .image-container { display: flex; justify-content: space-between; align-items: flex-start; margin-top: 10px; margin-bottom: 20px; } .image-item { max-width: 48%; } .image-item img { width: 100%; height: auto; } .image-description { font-size: 12px; text-align: center; color: #cccccc; margin-top: 5px; } p { margin-bottom: 15px; } .small-text { font-size: 10px; text-align: right; } .site-footer, footer, #footer, #colophon, .footer-widgets, .footer { display: none !important; }</style></head><body><div class="content-wrapper"><p>Tu en as marre de te faire engueuler pour rien par ta copine ?</p><p>Tu as un metier dont le patron ne reconnait pas ta vraie valeur ?</p><p>Rejoins notre famille et rien ne sera jamais plus pareil !</p><div class="image-container"><div class="image-item"><img src="https://lh3.googleusercontent.com/proxy/WAvUpEcd6nzTSh6y-JJagN8dKAbIJEO5DfAo0BIyDyn_YIuV5Ut9a3QxuJnwpCTtR9GcbOTcZ4EZlfJK5X8Xdj9Gam88ZqyDKBdcRg" alt="Lui, il est bien moche"><div class="image-description">Avant</div></div><div class="image-item"><img src="https://upload.wikimedia.org/wikipedia/en/thumb/6/69/Edward_Cullen.jpg/250px-Edward_Cullen.jpg" alt="Mais lui, c'est un pur beau gosse"><div class="image-description">Apres</div></div></div><p>Rejoignez notre confrerie pour seulement 99.95Đ (GigaDollar).</p><p>Vous aurez acces a toutes nos ressources pour reveler votre plein potentiel.</p><div class="small-text">Un petit abonnement hebdomadaire de 29.99Đ sera necessaire afin de continuer a beneficier de nos ressources.</div></div></body></html>
EOF
)


# URL of the images to be imported
IMAGE_URL1="https://lh3.googleusercontent.com/proxy/WAvUpEcd6nzTSh6y-JJagN8dKAbIJEO5DfAo0BIyDyn_YIuV5Ut9a3QxuJnwpCTtR9GcbOTcZ4EZlfJK5X8Xdj9Gam88ZqyDKBdcRg"
IMAGE_URL2="https://upload.wikimedia.org/wikipedia/en/thumb/6/69/Edward_Cullen.jpg/250px-Edward_Cullen.jpg"

# Step 1: Download the Images to the Media Library
IMAGE_ID1=$(wp media import $IMAGE_URL1 --allow-root --path='/var/www/wordpress' --porcelain)
IMAGE_ID2=$(wp media import $IMAGE_URL2 --allow-root --path='/var/www/wordpress' --porcelain)

# Step 2: Create the Article with the Images
ARTICLE_ID=$(wp post create \
    --allow-root \
    --path='/var/www/wordpress' \
    --post_type=page \
    --post_title="$TITLE" \
    --post_content="$CONTENT" \
    --post_status=publish \
    --porcelain)

# Add the first image as a thumbnail for the article
wp post meta add $ARTICLE_ID _thumbnail_id $IMAGE_ID1 --allow-root --path='/var/www/wordpress'

# Step 3: Set the Article as the Landing Page
wp option update show_on_front 'page' --allow-root --path='/var/www/wordpress'
wp option update page_on_front $ARTICLE_ID --allow-root --path='/var/www/wordpress'

# Output the IDs for verification
echo "Article ID: $ARTICLE_ID"
echo "Image 1 ID: $IMAGE_ID1"
echo "Image 2 ID: $IMAGE_ID2"
echo "Landing page set to article with ID: $ARTICLE_ID"

# Starting PHP-FPM
mkdir -p /run/php
/usr/sbin/php-fpm7.3 -F

