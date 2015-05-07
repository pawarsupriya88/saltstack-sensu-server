base:
#  '*':
#    - git

#  'sensu-client*':
#    - sensu.client
#    - test.server

  'sensu-server*':
    - CreateUser.server
#    - observium.server
#    - rabbitmq.server
#    - radis.server
#    - sensu.server
#    - sensu.client

#  'self-*':
#    - CreateUser.server
#    - cert
#    - test.server
