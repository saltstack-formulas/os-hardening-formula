include:
  - linux_hardening.network
  - linux_hardening.system
/etc/security/limits.d/10.disable_coredumps.conf:
  file.managed:
    - source: salt://linux_hardening/templates/limits.conf.tmpl
    - template: jinja
    - user: root
    - group: root
    - mode: 0444
/etc/profile.d/disable_coredumps.sh:
  file.managed:
    - source: salt://linux_hardening/templates/profile.conf.tmpl
    - template: jinja
    - user: root
    - group: root
    - mode: 0755
/etc/login.defs:
  file.managed:
    - source: salt://linux_hardening/templates/login.defs.tmpl
    - template: jinja
    - user: root
    - group: root
    - moe: 0400
