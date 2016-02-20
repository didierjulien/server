#!sbin/bash

# echo "Hello! Let's start by creating the sftp user and it's password"
# adduser webdeploy

###### DELETE THIS SECTION BEFORE RUNNING ####
sudo rm -R /var/www/vhosts/*
sudo rm -R /etc/apache2/sites-available/*.conf
##############################################

# Creating the vhosts directories and assigning values to dev and staging
echo "Please enter a value for the following vhosts"
echo "dev: "
read dev

echo "staging: "
read staging

echo "The dev environment is: $dev"
echo "The staging environment is: $staging"
echo "Is this correct? (yes/no)"
read answer

case $answer in
  y|yes|Y|Yes|YES) break ;;
  *) echo "Please enter value for the following vhosts"
  echo "dev: "
  read dev
  echo "staging: "
  read staging
  echo "The dev environment is: $dev"
  echo "The staging environment is: $staging"
esac

echo "Creating vhosts in /var/www/vhosts"
mkdir -p /var/www/vhosts/$dev
echo "Created /var/www/vhosts/$dev"
mkdir -p /var/www/vhosts/$staging
echo "Created /var/www/vhosts/$staging"

sleep 2

# Create the config files
echo "Creating apache config files"
touch /etc/apache2/sites-available/$dev.conf
touch /etc/apache2/sites-available/$staging.conf

echo "<VirtualHost *:80>
        ServerName $dev

        DocumentRoot /var/www/vhosts/$dev

        <Directory /var/www/vhosts/$dev>
            Options -Indexes +FollowSymLinks -MultiViews
            AllowOverride All
            AuthType Basic
            AuthName \"Preview\"
            AuthUserFile /etc/apache2/passwords
            Require valid-user
            Allow from 209.202.126.186
            Allow from 50.57.4.20
            Allow from .usersnap.com
            Allow from .screener.io
            Satisfy Any
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/$dev-error.log
        CustomLog ${APACHE_LOG_DIR}/$dev-access.log combined
        LogLevel warn
</VirtualHost>

<VirtualHost *:443>
        ServerName $dev

        DocumentRoot /var/www/vhosts/$dev

        <Directory /var/www/vhosts/$dev>
            Options -Indexes +FollowSymLinks -MultiViews
            AllowOverride All
            AuthType Basic
            AuthName \"Preview\"
            AuthUserFile /etc/apache2/passwords
            Require valid-user
            Allow from 209.202.126.186
            Allow from 50.57.4.20
            Allow from .usersnap.com
            Allow from .screener.io
            Satisfy Any
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/$dev-error.log
        CustomLog ${APACHE_LOG_DIR}/$dev-access.log combined
        LogLevel warn

        SSLEngine on
        SSLCertificateFile   /root/edlfb14.crt
        SSLCertificateKeyFile /root/edlfb14.key
        SSLCertificateChainFile /root/edlfb-ca.crt

        <FilesMatch \"\.(cgi|shtml|phtml|php)$\">
        SSLOptions +StdEnvVars
        </FilesMatch>

        BrowserMatch \"MSIE [2-6]\"                 nokeepalive ssl-unclean-shutdown                 downgrade-1.0 force-response-1.0
        BrowserMatch \"MSIE [17-9]\" ssl-unclean-shutdown

</VirtualHost>
" >> /etc/apache2/sites-available/$dev.conf

cat /etc/apache2/sites-available/$dev.conf
echo "dev config file created"

sleep 2

echo "<VirtualHost *:80>
        ServerName $staging

        DocumentRoot /var/www/vhosts/$staging

        <Directory /var/www/vhosts/$staging>
            Options -Indexes +FollowSymLinks -MultiViews
            AllowOverride All
            AuthType Basic
            AuthName \"Preview\"
            AuthUserFile /etc/apache2/passwords
            Require valid-user
            Allow from 209.202.126.186
            Allow from 50.57.4.20
            Allow from .usersnap.com
            Allow from .screener.io
            Satisfy Any
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/$staging-error.log
        CustomLog ${APACHE_LOG_DIR}/$staging-access.log combined
        LogLevel warn
</VirtualHost>

<VirtualHost *:443>
        ServerName $staging

        DocumentRoot /var/www/vhosts/$staging

        <Directory /var/www/vhosts/$staging>
            Options -Indexes +FollowSymLinks -MultiViews
            AllowOverride All
            AuthType Basic
            AuthName \"Preview\"
            AuthUserFile /etc/apache2/passwords
            Require valid-user
            Allow from 209.202.126.186
            Allow from 50.57.4.20
            Allow from .usersnap.com
            Allow from .screener.io
            Satisfy Any
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/$staging-error.log
        CustomLog ${APACHE_LOG_DIR}/$staging-access.log combined
        LogLevel warn

        SSLEngine on
        SSLCertificateFile   /root/edlfb14.crt
        SSLCertificateKeyFile /root/edlfb14.key
        SSLCertificateChainFile /root/edlfb-ca.crt

        <FilesMatch \"\.(cgi|shtml|phtml|php)$\">
        SSLOptions +StdEnvVars
        </FilesMatch>

        BrowserMatch \"MSIE [2-6]\"                 nokeepalive ssl-unclean-shutdown                 downgrade-1.0 force-response-1.0
        BrowserMatch \"MSIE [17-9]\" ssl-unclean-shutdown

</VirtualHost>
" >> /etc/apache2/sites-available/$staging.conf

cat /etc/apache2/sites-available/$staging.conf
echo "staging config file created"

echo "Enter htpasswd credentials: "
read creds

echo "$creds" >> /etc/apache2/passwords

sleep 2

echo "Assigning proper permissions to vhosts"
sudo chown -R webdeploy:www-data /var/www/vhosts/$dev
sudo chown -R webdeploy:www-data /var/www/vhosts/$staging

sudo chmod -R 775 /var/www/vhosts/$dev
sudo chmod -R 775 /var/www/vhosts/$staging

ls -la /var/www/vhosts/

sleep 2

echo "Enabling the dev and staging sites"
sudo a2ensite $dev.conf
sudo a2ensite $staging.conf
sudo service apache2 restart
