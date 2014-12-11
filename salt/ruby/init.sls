include:
  - xio_user

curl:
  pkg:
    - installed

rvm_gpg:
  cmd:
    - run
    - name: curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    - user: xio
    - unless: test -s "$HOME/.gnupg/secring.gpg"
    - require:
      - pkg: curl
      - user: xio

rvm:
  cmd:
    - run
    - name: curl -L get.rvm.io | bash -s -- --autolibs=read-fail
    - user: xio
    - unless: test -s "$HOME/.rvm/scripts/rvm"
    - require:
      - pkg: curl
      - user: xio

rvm_bashrc:
  cmd:
    - run
    - name: echo "[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm" >> $HOME/.bashrc && echo "rvm use ruby-2.1.2" >> $HOME/.bashrc
    - user: xio
    - require:
      - cmd: rvm
      - user: xio

rvm-deps:
  pkg.installed:
    - names:
      - make
      - g++
      - libreadline6-dev
      - zlib1g-dev
      - libssl-dev
      - libyaml-dev
      - libsqlite3-dev
      - sqlite3 
      - autoconf
      - libgdbm-dev
      - libncurses5-dev
      - automake 
      - libtool
      - bison
      - pkg-config
      - libffi-dev
      - nodejs

ruby:
  cmd:
    - run
    - name: rvm install 2.1.2
    - user: xio
    - require:
      - cmd: rvm_bashrc
      - user: xio
      - pkg: rvm-deps

