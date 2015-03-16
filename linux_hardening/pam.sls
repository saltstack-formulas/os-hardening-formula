{% from "linux_hardening/map.jinja" import hardening with context %}
{% from "linux_hardening/map.jinja" import pamdata with context %}

{{pamdata.pam_ccreds}}:
  pkg.removed
{% if hardening.pam.passwdqc_enabled %}
{{pamdata.pam_cracklib}}:
  pkg.removed
{{pamdata.pam_passwdqc}}:
  pkg.installed
passwdqc_config:
  file.managed:
    - name: {{pamdata.passwdqc_path}}
    - source: salt://linux_hardening/templates/pam_passwdqc.tmpl
    - user: root
    - group: root
    - mode: 0640
{% else %}
passwdqc_no_config:
  file.remove:
    -name: {{pamdata.passwdqc_path}}
{{pamdata.pam_passwdqc}}:
  pkg.removed
{% endif %}

{% if hardening.pam.auth_retries > 0 %}
libpam-modules:
  pkg.installed

tally2_config:
  file.managed:
    - name: {{pamdata.tally2_path}}
    - source: salt://linux_hardening/templates/pam_tally2.tmpl
    - user: root
    - group: root
    - mode: 0640
{% else %}
tally2_no_config:
  file.remove:
    - name: {{pamdata.tally2_path}}
{% endif %}

update_pam:
  cmd.wait:
    - name:/usr/sbin/pam-auth-update --package
    - watch:
      - file: tally2_config
      - file: tally2_no_config
      - file: passwdqc_config
      - file: passwdqc_no_config
