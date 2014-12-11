iptables-persistent:
  pkg.installed:
    - name: iptables-persistent

  file.managed:
    - user: root
    - group: root
    - mode: 0640
    - source: salt://iptables/template/rules.v4
    - name: /etc/iptables/rules.v4
    - require:
      - pkg: iptables-persistent

  service.running:
    - name: iptables-persistent
    - enable: True
    - reload: True
    - require:
      - file: iptables-persistent
    - watch: 
      - file: /etc/iptables/rules.v4
