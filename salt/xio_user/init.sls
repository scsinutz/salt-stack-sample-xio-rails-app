xio:
  group:
    - present
  user.present:
    - gid: xio
    - home: /home/xio
    - require:
      - group: xio

