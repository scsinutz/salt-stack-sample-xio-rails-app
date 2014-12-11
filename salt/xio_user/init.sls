xio:
  group:
    - present
  user.present:
    - gid: xio
    - home: /home/xio
    - shell: False
    - require:
      - group: xio

