{% from 'pkg/map.jinja' import pkg with context %}

{% if grains['os_family'] == 'RedHat' %}
yum-cron:
  pkg.installed:
    - name: {{ pkg.autoupdate.package }}

  service.running:
    - name: {{ pkg.autoupdate.service }}
    - enable: True
    - require:
      - pkg: yum-cron
{% endif %}
