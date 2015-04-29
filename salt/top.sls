base:
#  '*':
#    - git

#  'sensu-client*':
#    - sensu.client
#    - test.server

  'sensu-server*':
    - observium.server
#    - rabbitmq.server
#    - radis.server
#    - sensu.server
#    - sensu.client

#  'self-*':
#    - cert
#    - test.server
