#configure rabbitMQ repo

rabbitmq_repo:
  pkgrepo.managed:
    - humanname: RabbitMQ Repository
    - name: deb http://www.rabbitmq.com/debian/ testing main
    - file: /etc/apt/sources.list.d/rabbitmq.list
    - key_url: http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
    - require_in:
      - pkg: rabbitmq-server

# install rabbitMQ package and start the service

rabbitmq-server:
  pkg:
    - latest
    - name: rabbitmq-server
    - requires:
      - pkgrepo: rabbitmq-repo
  service:
    - running
    - enable: True
    - watch:
      - pkg: rabbitmq-server
  file.managed:
    - name: /etc/rabbitmq/rabbitmq.config
    - contents: |
        [
            {rabbit, [
            {ssl_listeners, [5671]},{ssl_options, [{cacertfile,"/etc/rabbitmq/ssl/cacert.pem"},{certfile,"/etc/rabbitmq/ssl/cert.pem"},{keyfile,"/etc/rabbitmq/ssl/key.pem"},{verify,verify_peer},{fail_if_no_peer_cert,true}]}
          ]}
        ].
    - require:
      - pkg: rabbitmq-server
  cmd.run:
   - cwd: /etc/rabbitmq/
   - names:
     - mkdir -p ssl


#Copy certificate on sensu server 
sensu-ca-cert-copy:
  file.managed:
    - source: salt://cert/ssl_certs/sensu_ca/cacert.pem
    - name: /etc/rabbitmq/ssl/cacert.pem
sensu-serv-cert-copy:
  file.managed:
    - source: salt://cert/ssl_certs/server/cert.pem
    - name: /etc/rabbitmq/ssl/cert.pem

sensu-serv-key-copy:
  file.managed:
    - source: salt://cert/ssl_certs/server/key.pem
    - name: /etc/rabbitmq/ssl/key.pem



# Add rabbitMQ vhost
sensu-rabbitmq-vhost:
  cmd.run:
    - name: rabbitmqctl add_vhost /sensu
    - unless: rabbitmqctl list_vhosts | grep -q /sensu
    - require:
      - service: rabbitmq-server

# Add RabbitMQ sensu user
sensu-rabbitmq-user:
  cmd.run:
    - name: rabbitmqctl add_user sensu mypass
    - unless: rabbitmqctl list_users | grep -q sensu
    - require:
      - service: rabbitmq-server

# change permission for sensu user
sensu-rabbitmq-permissions:
  cmd.run:
    - name: rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
    - unless: rabbitmqctl list_user_permissions -p /sensu sensu | grep /sensu | grep -q '\.\*'
    - require:
      - cmd: sensu-rabbitmq-vhost
      - cmd: sensu-rabbitmq-user
      
