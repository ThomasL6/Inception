FROM alpine:3.19

#Create the web root directory after upgrade
RUN apk update && apk upgrade && apk add nginx && mkdir -p /var/www/html/

# Copy the Nginx configuration to the container
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Copy the default site configuration to the appropriate directory
COPY ./conf/default.conf /etc/nginx/http.d/default.conf

#OpenSSL and generate a self-signed SSL certificate for Nginx
RUN apk add openssl && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout \
    /etc/ssl/private/nginx-selfsigned.key -out \
    /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=FR/ST=Normandie/L=LeHavre/O=42Network/OU=42LeHavre/CN=inception"

# Create a new user 'www' with no password and assign it to the 'www' group
RUN adduser -D -g 'www' www && chown -R www:www /run/nginx/ && chown -R www:www /var/www/html/

# Expose port 443 for HTTPS traffic
EXPOSE 443/tcp

# Start Nginx to keep the container running
CMD [ "nginx", "-g", "daemon off;" ]
