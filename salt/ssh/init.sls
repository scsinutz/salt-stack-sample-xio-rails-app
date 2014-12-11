openssh-server:
  pkg.installed:
    - name: openssh-server

  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://ssh/template/sshd_config
    - name: /etc/ssh/sshd_config
    - require:
      - pkg: openssh-server

  service.running:
    - name: ssh
    - enable: True
    - reload: True
    - require:
      - file: openssh-server
    - watch: 
      - file: /etc/ssh/sshd_config
