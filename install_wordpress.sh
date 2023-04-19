#!/bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo service httpd start
sudo yum install -y mysql

sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2


sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo rm -f latest.tar.gz

export MYSQL_HOST=database-1.cgwzuzkgdaxy.us-east-1.rds.amazonaws.com
mysql --user=admin --password=password database-1

CREATE USER 'admin' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO admin;
FLUSH PRIVILEGES;
Exit

cd wordpress
cp wp-config-sample.php wp-config.php

sudo cat << EOF > /var/www/html/wp-config.php
<?php
define( 'DB_NAME', 'wordpress' );
define( 'DB_USER', 'admin' );
define( 'DB_PASSWORD', 'password' );
define( 'DB_HOST', 'database-1.cgwzuzkgdaxy.us-east-1.rds.amazonaws.com' );

define('AUTH_KEY',         'It^YxCXAP}SF#z?v;`_~N->9jJnf^T-*Ko{TF].UqI{a]Wj1IUC`KGHHLi,1>,>h');
define('SECURE_AUTH_KEY',  '}tx6)=8:>q%dJP-l0a=H^N`%v^PC(k<jz8XI+SNi.uJ(RtT,4-0$wJec8b_3/TG5');
define('LOGGED_IN_KEY',    '[kTQ(m~~L$*:7Vo+|w%vRM|F}M*$cs]V) x$@+2r0-=&3O_@h=q/^$|8J=2Tg{6|');
define('NONCE_KEY',        'iBjBN*Y&OQTp~Y5(Jh:W{^&R7Jw{O|^(VgE-ms ) | l9B7H8cVD|@LO-/2955iL');
define('AUTH_SALT',        '<J1r3(kE,cT`V<~j:e5baDj9k>%||EbZ0KQ(J{o4YOF$qe_1C;JxeLL@GKaNiv0O');
define('SECURE_AUTH_SALT', 'MjPo@_zE<}xM#fcgvt|Y^4&mNd=6~q&i0z>6`A/<%|ea~K{d}+J sZu}MWK|<zGl');
define('LOGGED_IN_SALT',   '1:+-+]V-unFM._n~#.De.N-S+qU!}R T%EDgJ%c6}I*JWCvMy9uNR`},U#zkV,sO');
define('NONCE_SALT',       '7;%!Cj1@6cWX;|9Pj~Ol#b;1LMY8IQ3ZYB-n_no{6__wmy#`SQ.D41ym/=: c} +');

$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
EOF

sudo cp -r /wordpress/* /var/www/html/
sudo service httpd restart
