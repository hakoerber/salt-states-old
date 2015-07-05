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

{% elif grains['os_family'] == 'Debian' %}
50unattended-upgrades:
  file.managed:
    - name: {{ pkg.autoupdate.conf.conf_50unattended_upgrades.path }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: {{ pkg.autoupdate.conf.conf_50unattended_upgrades.source }}
    - require:
      - pkg: unattended-upgrades

20auto-upgrades:
  file.managed:
    - name: {{ pkg.autoupdate.conf.conf_20auto_upgrades.path }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: {{ pkg.autoupdate.conf.conf_20auto_upgrades.source }}
    - require:
      - pkg: unattended-upgrades
{% endif %}
