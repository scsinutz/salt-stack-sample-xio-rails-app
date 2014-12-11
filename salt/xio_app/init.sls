github_sample-xio-rails-app:
  git.latest:
    - name: https://github.com/OTOYInc/sample-xio-rails-app.git
    - rev: master
    - target: /opt/xio-app

/opt/xio-app:
  file.directory:
    - user: xio
    - group: xio
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

application.yml:
  file.managed:
    - name: /opt/xio-app/config/application.yml
    - source: salt://xio_app/template/application.yml
    - user: xio
    - group: xio
    - mode: 755
    - require:
      - file: /opt/xio-app

Bundle-and-Rake:
  cmd:
    - run
    - name: bundle && bundle exec rake db:migrate
    - cwd: /opt/xio-app
    - env: 
      - PATH: /home/xio/.rvm/gems/ruby-2.1.2/bin:/home/xio/.rvm/gems/ruby-2.1.2@global/bin:/home/xio/.rvm/rubies/ruby-2.1.2/bin:/home/xio/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/xio/.rvm/bin
    - user: xio
    - require:
      - file: /opt/xio-app
      - git: github_sample-xio-rails-app

init:
  file.managed:
    - name: /etc/init.d/railsweb
    - source: salt://xio_app/template/railsweb
    - user: xio
    - group: xio
    - mode: 755
    - require:
      - cmd: Bundle-and-Rake

upstart:
  cmd:
    - run
    - cwd: /etc/init.d
    - name: update-rc.d railsweb defaults
    - unless: service --status-all | grep -o railsweb
    - require:
      - file: init

railsweb-config-dir:
  file.directory:
    - name: /etc/railsweb
    - user: xio
    - group: xio
    - mode: 755
    - require:
      - cmd: upstart

unicorn-config-file:
   file.managed:
      - name: /etc/railsweb/unicorn.conf
      - source: salt://xio_app/template/unicorn.conf
      - user: xio
      - group: xio
      - require:
        - file: railsweb-config-dir

xio-service:
  service.running:
    - name: railsweb
    - enable: True
    - require:
      - file: init
