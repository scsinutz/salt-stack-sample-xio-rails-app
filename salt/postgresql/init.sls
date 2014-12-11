postgresql_repo:

  pkgrepo.managed:
    - humanname: PostgreSQL
    - name: deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main
    - dist: trusty-pgdg
    - file: /etc/apt/sources.list.d/pgdg.list
    - key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc
    - keyid: ACCC4CF8
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: postgresql-9.3

postgresql-9.3:

  pkg.installed:
    - names:
      - postgresql-9.3
      - postgresql-server-dev-9.3
      - libpq-dev

  service.running:
    - name: postgresql
    - enable: True
    - watch:
      - file: /etc/postgresql/9.3/main/pg_hba.conf

sample-xio-rails:

  postgres_user.present:
    - name: sample-xio-rails-app
    - password: sample-xio-rails-app # this should live in pillar data
    - runas: postgres
    - require:
      - service: postgresql

  postgres_database.present:
    - name: sample-xio-rails-app_production
    - encoding: UTF8
    - lc_ctype: en_US.UTF8
    - lc_collate: en_US.UTF8
    - template: template0
    - owner: xio
    - runas: postgres
    - require:
      - postgres_user: xiouser
      
