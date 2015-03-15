{% set base_blacklist = salt['pillar.get']('hardening:sugid:base_blacklist',
  ['/usr/bin/rcp', '/usr/bin/rlogin', '/usr/bin/rsh',
  '/usr/libexec/openssh/ssh-keysign',
  '/usr/lib/openssh/ssh-keysign',
  '/sbin/netreport',
  '/usr/sbin/usernetctl',
  '/usr/sbin/userisdnctl',
  '/usr/sbin/pppd',
  '/usr/bin/lockfile',
  '/usr/bin/mail-lock',
  '/usr/bin/mail-unlock',
  '/usr/bin/mail-touchlock',
  '/usr/bin/dotlockfile',
  '/usr/bin/arping',
  '/usr/sbin/uuidd',
  '/usr/bin/mtr',
  '/usr/lib/evolution/camel-lock-helper-1.2',
  '/usr/lib/pt_chown',
  '/usr/lib/eject/dmcrypt-get-device',
  '/usr/lib/mc/cons.saver'
]) %}
{% set blacklist = salt['pillar.get']('hardening:sugid:blacklist',[]) %}
{% set final_blacklist = base_blacklist|list + blacklist|list %}
{% for file in final_blacklist %}
remove_{{file}}:
  cmd.run:
    - name: /bin/chmod ug-s {{file}}
    - onlyif: /usr/bin/test -e {{file}}
    - unless: /usr/bin/test -f {{file}} -a -u {{file}} -o -f {{file}} -a -g {{file}}
{% endfor %}
check_sugid_bits:
  cmd.script:
    - source: salt://linux_hardening/templates/remove_sugid_bits.tmpl
    - template: jinja
    - user: root
    - group: root
    - mode: 0500
