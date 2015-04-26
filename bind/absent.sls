{% from "bind/map.jinja" import bind with context %}

bind:
  pkg.removed:
    - name: {{ bind.package }}
    - require:
      - service: bind

  service.dead:
    - name: {{ bind.service }}
    - enable: false
