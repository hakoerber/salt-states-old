{% from "emby/map.jinja" import emby with context %}

{% if grains['os_family'] == 'RedHat' %}
emby_repository:
  pkg.installed:
    - sources:
      - {{ emby.repository.name }}: {{ emby.repository.url }}
    - require:
      - pkg: epel-release
    - require_in:
      - pkg: emby
{% endif %}

emby:
  pkg.installed:
    - name: {{ emby.package }}

  service.running:
    - name: {{ emby.service }}
    - enable: true
    - require:
      - pkg: emby
