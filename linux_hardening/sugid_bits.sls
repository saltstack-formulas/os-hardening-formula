{% set base_blacklist = salt['pillar.get']('hardening:sugid:base_blacklist',
  [# blacklist as provided by NSA
  '/usr/bin/rcp', '/usr/bin/rlogin', '/usr/bin/rsh',
  # sshd must not use host-based authentication (see ssh cookbook)
  '/usr/libexec/openssh/ssh-keysign',
  '/usr/lib/openssh/ssh-keysign',
  # misc others
  # not normally required for user
  '/sbin/netreport',
  # modify interfaces via functional accounts
  '/usr/sbin/usernetctl',
  # connecting to ...
  # no isdn...
  '/usr/sbin/userisdnctl',
  # no ppp / dsl ...
  '/usr/sbin/pppd',
  # lockfile
  '/usr/bin/lockfile',
  '/usr/bin/mail-lock',
  '/usr/bin/mail-unlock',
  '/usr/bin/mail-touchlock',
  '/usr/bin/dotlockfile',
  # need more investigation, blacklist for now
  '/usr/bin/arping',
  '/usr/sbin/uuidd',
  # investigate current state...
  '/usr/bin/mtr',
  # investigate current state...
  '/usr/lib/evolution/camel-lock-helper-1.2',
  # pseudo-tty, needed?
  '/usr/lib/pt_chown',
  '/usr/lib/eject/dmcrypt-get-device',
  # midnight commander screensaver
  '/usr/lib/mc/cons.saver'
]) %}
{% set blacklist = salt['pillar.get']('hardening:sugid:blacklist',[]) %}
{% set final_blacklist = base_blacklist|list + blacklist|list %}
{% for file in final_blacklist %}
remove_{{file}}:
  cmd.run:
    - name: /bin/chmod ug-s {{file}}
    - unless: /usr/bin/test -f {{file}} -a -u {{file}} -o -f {{file}} -a -g {{file}}
{% endfor %}
check_sugid_bits:
  cmd.script:
    - source: salt://linux/hardening/templates/remove_sugid_bits.tmpl
    - template: jinja
    - user: root
    - group: root
    - mode: 0500
