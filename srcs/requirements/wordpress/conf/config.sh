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
    --title="Le Reclusiam" \
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
TITLE="Enlist Now !!"
CONTENT=$(cat <<EOF
<!DOCTYPE html>
<html>
<head>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            background-color: #f2e7bf;
            color: #000000;
            font-family: Arial, sans-serif;
        }
        .content-wrapper {
            padding: 20px;
        }
        .image-container {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-top: 10px;
            margin-bottom: 20px;
        }
        .image-item {
            max-width: 48%;
            justify-self: center;
        }
        .image-item img {
            width: 100%;
            height: auto;
        }
        .image-description {
            font-size: 12px;
            text-align: center;
            color: #cccccc;
            margin-top: 5px;
        }
        p {
            margin-bottom: 15px;
        }
        .small-text {
            font-size: 10px;
            text-align: center;
        }
        .site-footer, footer, #footer, #colophon, .footer-widgets, .footer {
            display: none !important;
        }
    </style>
</head>
<body>
    <div class="content-wrapper">
        <div class="image-item">
            <img src="https://ih1.redbubble.net/image.5309325659.5677/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.jpg" alt="Krieg commissar">
            <div class="image-description">Join the guard, sonny!</div>
        </div>
        <p>Incapable de comprendre de quoi parles le magos lors des sermons le dimanche ?</p>
        <p>Tu ne veux pas passer pour un heretique envers l'empereur en confondant ses glorieux anges avec les ennemis de l'humanite  ?</p>
        <p>Rejoins les rangs de l'Astra Militarum!</p>

        <div class="image-container">
            <div class="image-item">
                <img src="https://www.belloflostsouls.net/wp-content/uploads/2018/11/Ultramarine_Chapter.jpg" alt="Ultramarine">
                <div class="image-description">Bien</div>
            </div>
            <div class="image-item">
                <img src="https://wh40k.lexicanum.com/mediawiki/images/thumb/0/02/ChaosRising.jpg/450px-ChaosRising.jpg" alt="Black Legion">
                <div class="image-description">Pas Bien</div>
            </div>
        </div>

        <p>Profite de nombreuses opportunites pour te former et defendre le royaume de l'empereur.</p>
        <p>La Garde Imperiale n'attends plus que vous!</p>

        <div class="small-text">
            Un petit abonnement hebdomadaire de 29.99Đ sera nécessaire afin de continuer a recevoir les rations et autres pieces d'equipements. Car comme le dit
            le canon de Saint Maximin du Calice Flamboyant : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam odio massa, consequat at leo"
        </div>
    </div>
</body>
</html>
EOF
)
# URL of the images to be imported
IMAGE_URL1="https://ih1.redbubble.net/image.5309325659.5677/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.jpg"
IMAGE_URL2="https://www.belloflostsouls.net/wp-content/uploads/2018/11/Ultramarine_Chapter.jpg"
IMAGE_URL3="https://wh40k.lexicanum.com/mediawiki/images/thumb/0/02/ChaosRising.jpg/450px-ChaosRising.jpg"

# Step 1: Download the Images to the Media Library
IMAGE_ID1=$(wp media import $IMAGE_URL1 --allow-root --path='/var/www/wordpress' --porcelain)
IMAGE_ID2=$(wp media import $IMAGE_URL2 --allow-root --path='/var/www/wordpress' --porcelain)
IMAGE_ID3=$(wp media import $IMAGE_URL3 --allow-root --path='/var/www/wordpress' --porcelain)


# Step 2: Create the Article with the Images
ARTICLE_ID=$(wp post create \
    --allow-root \
    --path='/var/www/wordpress' \
    --post_type=page \
    --post_title="$TITLE" \
    --post_content="$CONTENT" \
    --post_status=publish \
    --porcelain)

# Enable comments on the page
wp post update $ARTICLE_ID --comment_status=open --allow-root --path='/var/www/wordpress'

# Add the first image as a thumbnail for the article
wp post meta add $ARTICLE_ID _thumbnail_id $IMAGE_ID1 --allow-root --path='/var/www/wordpress'

# Step 3: Set the Article as the Landing Page
wp option update show_on_front 'page' --allow-root --path='/var/www/wordpress'
wp option update page_on_front $ARTICLE_ID --allow-root --path='/var/www/wordpress'

# Output the IDs for verification
echo "Article ID: $ARTICLE_ID"
echo "Image 1 ID: $IMAGE_ID1"
echo "Image 2 ID: $IMAGE_ID2"
echo "Image 2 ID: $IMAGE_ID3"
echo "Landing page set to article with ID: $ARTICLE_ID"

# Starting PHP-FPM
mkdir -p /run/php
/usr/sbin/php-fpm7.3 -F

