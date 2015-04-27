# configure sensu repo
sensu-pkgrepo:
  pkgrepo.managed:
    - humanname: Sensu
    - name: deb http://repos.sensuapp.org/apt sensu main
    - file: /etc/apt/sources.list
    - keyid: 7580C77F
    - keyserver: keyserver.ubuntu.com
    - key_url: http://repos.sensuapp.org/apt/pubkey.gpg
    - require_in:
      - pkg: sensu-package

# install sensu package
sensu-package:
  pkg.installed:
    - name: sensu
    - name: uchiwa
    - order: 1



# make ssl directory for sensu for secure connection with rabbitMQ
sensu.install:
  cmd.run:
    - name: mkdir -p /etc/sensu/ssl
    - order: 2


sensu-client-cert-onserver:
  file.managed:
    - source: salt://cert/ssl_certs/client/cert.pem
    - name: /etc/sensu/ssl/cert.pem
    - order: 3

sensu-client-key-onserver:
  file.managed:
    - name: /etc/sensu/ssl/key.pem
    - source: salt://cert/ssl_certs/client/key.pem
    - order: 4

# copy config.json on server
sensu-server-config:
  file.managed:
    - name: /etc/sensu/config.json
    - source: salt://sensu/server-config.json
    - order: 5 
sensu-client-config:
  file.managed:
    - name: /etc/sensu/conf.d/client.json
    - source: salt://sensu/client-config.json
    - order: 6

sensu-api-json-config:
  file.managed:
    - name: /etc/sensu/conf.d/api.json
    - source: salt://sensu/api.json
    - order: 7
sensu-api-radis-config:
  file.managed:
    - name: /etc/sensu/conf.d/radis.json
    - source: salt://sensu/radis.json
    - order: 8
sensu-rabbitmq-json-config:
  file.managed:
    - name: /etc/sensu/conf.d/rabbitmq.json
    - source: salt://sensu/rabbitmq.json
    - template: jinja
    - defaults:
      IP_rabbitmq: 172.20.70.71 #{{ pillar['rabbitmq']['IP'] }}
    - context:
      IP_rabbitmq: {{ pillar['rabbitmq']['IP'] }}
    - order: 9
sensu-uchiwa-json-config:
  file.managed:
    - name: /etc/sensu/uchiwa.json
    - source: salt://sensu/uchiwa.json
    - order: 10
# Enable the Sensu services to start automatically
sensu-service-start:
  cmd.run:
    - names:
      - update-rc.d sensu-server defaults
      - update-rc.d sensu-client defaults
      - update-rc.d sensu-api defaults
      - update-rc.d uchiwa defaults
      - service sensu-server start
      - service sensu-client start
      - service sensu-api start
      - service uchiwa start
    - order: 30
  service.running:
    - names: 
      - sensu-server
      - sensu-client
      - sensu-api
      - uchiwa  
    - order: 31

