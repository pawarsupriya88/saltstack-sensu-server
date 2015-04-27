# configure sensu repo
sensu-pkgrepo-client:
  pkgrepo.managed:
    - humanname: Sensu
    - name: deb http://repos.sensuapp.org/apt sensu main
    - file: /etc/apt/sources.list
    - keyid: 7580C77F
    - keyserver: keyserver.ubuntu.com
    - key_url: http://repos.sensuapp.org/apt/pubkey.gpg
    - require_in:
      - pkg: sensu-package-client

# install sensu package
sensu-package-client:
  pkg.installed:
    - name: sensu

# make ssl directory for sensu for secure connection with rabbitMQ

sensu.install-client:
  cmd.run:
    - name: mkdir -p /etc/sensu/ssl

sensu-client-cert:
  file.managed:
    - source: salt://cert/ssl_certs/client/cert.pem
    - name: /etc/sensu/ssl/cert.pem

sensu-client-key:
  file.managed:
    - name: /etc/sensu/ssl/key.pem
    - source: salt://cert/ssl_certs/client/key.pem



