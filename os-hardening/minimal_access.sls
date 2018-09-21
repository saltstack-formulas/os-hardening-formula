{%- from "os-hardening/map.jinja" import hardening with context %}

hardening-read-only-folders:
  file.directory:
    - names: {{ hardening.read_only_folders }}
    - user: root
    - group: root
    - follow_symlinks: False
    - dir_mode: 755
    - file_mode: 755
    - recurse:
      - user
      - group
      - mode

etc-shadow-file:
  file.managed:
    - name: /etc/shadow
    - user: root
    - group: root
    - mode: 0600
    - replace: False

{%- if hardening.allow_change_user %}
allow-change-user:
  file.managed:
    - name: /bin/su
    - mode: 0750
    - replace: False
{% endif %}

{%- if hardening.allow_sudo %}
allow-sudo:
  file.managed:
    - name: /usr/bin/sudo
    - user: root
    - group: root
    - mode: 4755
    - replace: False
{% endif %}
