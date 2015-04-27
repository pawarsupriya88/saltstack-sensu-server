# remove all ssl files
remove-ssl-files:
  cmd.run:
    - cwd: /srv/salt/cert
    - names:
      - rm -rf ssl*

# wget ssl tar used to generate certificate to communicate rabbitMQ

wget-ssl:
  cmd.run:
    - cwd: /srv/salt/cert
    - names:
      - wget http://sensuapp.org/docs/0.13/tools/ssl_certs.tar && tar -xvf ssl_certs.tar

# generate certificate
generate-cert:
  cmd.run:
    - cwd: /srv/salt/cert/ssl_certs
    - names:
      - ./ssl_certs.sh generate
