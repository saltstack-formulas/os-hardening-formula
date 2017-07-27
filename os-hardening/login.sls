/etc/login.defs:
  file.managed:
    - source: salt://os-hardening/templates/login.defs.tmpl
    - template: jinja
    - user: root
    - group: root
    - mode: 0400
