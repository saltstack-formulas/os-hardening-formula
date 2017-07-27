{%- from "os-hardening/map.jinja" import hardening with context %}

disable_coredumps.sh:
  file.managed:
    - name: /etc/profile.d/disable_coredumps.sh
    - source: salt://os-hardening/templates/profile.conf.tmpl
    - template: jinja
    - user: root
    - group: root
    - mode: 755

/etc/profile.d/autologout.sh:
  file.managed:
    - contents: |
        TMOUT={{ hardening.auto_logout }}
        TIMEOUT={{ hardening.auto_logout }}
        readonly TMOUT
        readonly TIMEOUT
        export TMOUT
        export TIMEOUT
    - mode: 755
