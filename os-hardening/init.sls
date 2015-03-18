include:
  - os-hardening.network
  - os-hardening.system
  - os-hardening.sugid_bits

limits_hardcore:
  file.managed:
    - name: /etc/security/limits.d/10.hardcore.conf
    - source: salt://os-hardening/templates/limits.conf.tmpl
    - template: jinja
    - user: root
    - group: root
    - mode: 444
disable_coredumps.sh:
  file.managed:
    - name: /etc/profile.d/disable_coredumps.sh
    - source: salt://os-hardening/templates/profile.conf.tmpl
    - template: jinja
    - user: root
    - group: root
    - mode: 755
