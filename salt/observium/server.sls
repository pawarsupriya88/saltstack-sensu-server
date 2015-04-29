# install dependancy packages required for observium
Install_Package:
  pkg.installed:
    - pkgs:
      - libapache2-mod-php5
      - php5-cli
      - php5-mysql
      - php5-gd
      - php5-mcrypt
      - php5-json
      - php-pear
      - snmp
      - fping
      - mysql-server
      - mysql-client
      - python-mysqldb
      - rrdtool
      - subversion
      - whois
      - mtr-tiny
      - ipmitool
      - graphviz
      - imagemagick
      - libvirt-bin
    - order: 1
  cmd.run:
    - cwd: /opt
    - names:
      - rm -rf /opt/observium*
    - order: 2 
Make_dir:
  cmd.run:
    - name: mkdir -p /opt/observium
    - order: 9
Wget_observium:
  cmd.run:
    - cwd: /opt/
    - names:
      - wget http://www.observium.org/observium-community-latest.tar.gz && tar zxvf observium-community-latest.tar.gz
    - order: 10

# Copy config.php on observium
Change_cponfig:
  file.managed:
    - name: /opt/observium/config.php
    - source: salt://observium/config-DB.php
    - template: jinja
    - context: 
      USERNAME: {{ pillar['mysql']['USERNAME'] }}
      PASSWORD: {{ pillar['mysql']['PASSWORD'] }}
    - order: 20

  cmd.run:
    - cwd: /opt/observium
    - names:
      - mysqladmin -u root password {{ pillar['mysql']['PASSWORD'] }}
    - order: 21

# Create the MySQL database:

Create_DB:
  cmd.run:
    - names:
      - mysql -u{{ pillar['mysql']['USERNAME'] }} -p{{ pillar['mysql']['PASSWORD'] }} -e "CREATE DATABASE observium DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"

      - mkdir -p /opt/observium/rrd
    - order: 23
  file.managed:
    - name: /etc/apache2/sites-available/000-default.conf
    - source: salt://observium/default.conf
    - order: 24

Change_DB_Privileges:
  cmd.run:
    - cwd: /opt/observium/ 
    - names:
      -  mysql -u{{ pillar['mysql']['USERNAME'] }} -p{{ pillar['mysql']['PASSWORD'] }} -e " GRANT ALL PRIVILEGES ON observium.* TO 'observium'@'localhost' IDENTIFIED BY 'Abc';"
      - php includes/update/update.php
      - mkdir -p /opt/observium/logs
      - chown www-data:www-data /opt/observium/rrd
      - php5enmod mcrypt
      - a2enmod rewrite
      - apache2ctl restart
    - order: 25

# Add admin user in observium
  
Copy_Default_Conf:
  cmd.run:
    - cwd: /opt/observium/
    - name: ./adduser.php {{ pillar['observium']['user'] }}  {{ pillar['observium']['pass'] }}  {{ pillar['observium']['level'] }}
    - order: 26

