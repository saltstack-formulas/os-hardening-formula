{% from "linux_hardening/map.jinja" import hardening with context %}
{% for dir in hardening.read_only_folders %}
{{dir}}:
  file.directory:
    - user: root
    - group: root
    - follow_symlinks: True
    - dir_mode: 755
    - file_mode: 755
    - recurse:
      - user
      - group
      - mode
{% endfor %}
/etc/shadow:
  file.managed:
    - user: root
    - group: root
    - mode: 0600
{% if hardening.allow_change_user %}
/bin/su:
  file.managed:
    - mode: 0750
{% endif %}
