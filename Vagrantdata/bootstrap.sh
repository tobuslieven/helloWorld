# ------
# Config
# ------
MYSQL_ROOT_PASSWORD='password'


# ----------------
# Installing Stuff
# ----------------
apt-get update

#
# Install Vim
#
apt-get install vim-nox

#
# Apache Stuff
#
# Update apt package manager and install apache2.
apt-get install -y apache2

# Set Apache User
# We make the Apache user the same as the command line user (vagrant) so that symfony's
# console operations (eg clearing the cache) are able to delete files and folders
# created by the web server without permission issues that otherwise get in the way.
cd /etc/apache2
cp envvars envvars.$(date '+%Y%m%d:%H:%M:%S').bak
sed -i '/export APACHE_RUN_USER=/c\export APACHE_RUN_USER=vagrant' envvars
sed -i '/export APACHE_RUN_GROUP=/c\export APACHE_RUN_GROUP=vagrant' envvars
# We need to use init.d NOT apachectl restart as that does not cause the parent·
# process to exit, so the use can't change.·
# http://serverfault.com/questions/506162/apache-apachectl-restart-does-not-reload-envvars
/etc/init.d/apache2 restart

# Copy our myApache.conf file to the Apache conf directory and enable it.
ln -fs /vagrant/Vagrantdata/myApache.conf /etc/apache2/conf-available/
a2enconf myApache.conf

# Apache mod rewrite is installed but not enabled in default Ubuntu, so·
# we will enable it now.
a2enmod rewrite

# Disable Default Site 000-default.conf
a2dissite 000-default.conf

# Map Apache Webroot To Shared Directory
# Map /var/www to vagrant sites root.
# If /var/www isn't a link then...
if ! [ -L /var/www ]; then
    # Remove /var/www and recreate it as a link to the vagrant root.
    rm -rf /var/www
    ln -fs /vagrant/sites /var/www
fi

#
# Installing Nodejs
#
# Install node and npm

#
# MySQL Stuff
#
#debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
#debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
#apt-get install -y mysql-server-5.6


#
# Installing MemCached
#
#apt-get install -y memcached


#
# PHP Stuff
#
# Install php5 and a bunch of modules for it.
# All modules gotten in this way seem to be enabled automatically.
apt-get install -y php5
apt-get install -y libapache2-mod-php5
#apt-get install -y php5-xdebug

# MCrypt needs some care as it doesn't auto enable itself. You have to·
# manually point php to the .so file. I am doing that in myPHP.ini.
#apt-get install -y php5-mcrypt
#apt-get install -y php5-mysql
#apt-get install -y php5-curl
#apt-get install -y php5-memcached

# Imagemagick is used by BinaryStore to generate thumbnails etc.
#apt-get install -y php5-imagick

# Xsl is used by sorted food and future others to generate site maps.
#apt-get install -y php5-xsl

# Xdebug is super useful and the default ubuntu version has a slight bug in the profiler
# that prevents closures from being profiled. So we will install a newer version with PECL.
#apt-get install -y php5-dev
#pecl install xdebug-2.3.2
#php5enmod xdebug

# Copy our myPHP.ini file to the php ini directory.
ln -fs /vagrant/Vagrantdata/myPHP.ini /etc/php5/apache2/conf.d/myPHP.ini
ln -fs /vagrant/Vagrantdata/myPHP.ini /etc/php5/cli/conf.d/myPHP.ini


#
# Sites
#
cd /vagrant/sites


#
# Enable Apache Vhost Sites
#
# My Site
ln -fs /vagrant/Vagrantdata/vhosts/helloWorld.dev.conf /etc/apache2/sites-available/helloWorld.dev.conf
a2ensite helloWorld.dev

