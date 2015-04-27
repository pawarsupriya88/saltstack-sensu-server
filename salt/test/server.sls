test-mkdir:

  cmd.run:
    - cwd: /tmp
    - names:
      - mkdir {{ pillar['rabbitmq']['test'] }}
