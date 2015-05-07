
CreateUser:
  user:
    - present
    - fullname: {{ pillar['fullname']}}
    - name: {{ pillar['name']}}
    - shell: {{ pillar['shell']}}
    - home: {{ pillar['home']}}
    - uid: {{ pillar['uid']}}
    - gid: {{ pillar['gid']}}
    - passward: {{ pillar['passward']}}
    - enforce_password: True
    - groups:
      - {{ pillar['group']}}
      - sudo
    - require:
      - group: {{ pillar['group']}}
    - order: 20
  group:
    - present
    - gid: {{ pillar['gid']}}
    - name: {{ pillar['group']}}
    - order: 10
  cmd.run:
    - name: echo -e '{{ pillar['passward']}}\n{{ pillar['passward']}}' | sudo passwd {{ pillar['name']}}
    - order: 30

/etc/ssh/sshd_config:
  file.replace:
    - pattern: #PasswordAuthentication yes
    - repl: PasswordAuthentication yes

#/etc/sudoers:
#  file.append:
#    - text:
#      - abc    ALL=(ALL:ALL) ALL
