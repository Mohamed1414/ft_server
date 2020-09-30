FROM debian:buster

COPY srcs/db.sql /tmp/
COPY srcs/wordpress.sql /tmp/

RUN apt update && \
	apt install -y nginx mariadb-server php7.3-fpm php7.3-mbstring php7.3-mysql openssl vim && \
	service mysql start && \
	mysql -u root --password= < /tmp/db.sql && \
	mysql wordpress -u root --password= < /tmp/wordpress.sql && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42telefonica/CN=127.0.0.1" \
	-keyout /etc/ssl/private/mbahstou.key \
	-out /etc/ssl/certs/mbahstou.crt && \
	openssl dhparam -out /etc/nginx/dhparam.pem 1042

COPY srcs/wordpress /var/www/html/wordpress
COPY srcs/phpmyadmin /var/www/html/phpmyadmin
COPY srcs/default /etc/nginx/sites-available/

RUN chown -R www-data:www-data /var/www/* && \
	chmod -R 755 /var/www/*

CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start && \
	bash
