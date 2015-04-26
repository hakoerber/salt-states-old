{% from "bind/map.jinja" import bind with context %}

bind:
  pkg.installed:
    - name: {{ bind.package }}

  service.running:
    - name: {{ bind.service }}
    - enable: true
    - require:
      - pkg: bind


