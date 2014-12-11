nginx_install:
      
  pkg.installed:
    - name: nginx

  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - pkg: nginx 
    - watch: 
      - file: /etc/nginx/conf.d/xio.conf
      - file: /etc/nginx/nginx.conf

/var/log/nginx:
  file.directory:
    - user: xio
    - group: adm
    - mode: 750
    - require:
      - pkg: nginx

nginx_config:
 file.managed:
    - user: xio
    - group: xio
    - mode: 755
    - source: salt://nginx/template/nginx.conf
    - name: /etc/nginx/nginx.conf
    - require:
      - pkg: nginx

xio-virt-host:
 file.managed:
    - user: xio
    - group: xio
    - mode: 755
    - source: salt://nginx/template/xio.conf.jinja
    - name: /etc/nginx/conf.d/xio.conf
    - template: jinja
    - require:
      - pkg: nginx
