{% from 'pkg/map.jinja' import pkg with context %}

{% if grains['os_family'] == 'RedHat' %}
yum-cron.conf:
  file.managed:
    - name: {{ pkg.autoupdate.conf_path }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: {{ pkg.autoupdate.conf_source }}
    - template: jinja
    - require:
      - pkg: yum-cron
    - watch_in:
      - service: yum-cron
{% endif %}
