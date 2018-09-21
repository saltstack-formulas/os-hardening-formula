limits_hardcore:
  file.managed:
    - name: /etc/security/limits.d/10.hardcore.conf
    - source: salt://os-hardening/templates/limits.conf.tmpl
    - template: jinja
    - user: root
    - group: root
    - mode: 444
