{% from "vnstat/map.jinja" import vnstat with context %}

vnstat:
  pkg.removed:
    - name: {{ vnstat.package }}
    - require:
      - service: vnstat

  service.dead:
    - name: {{ vnstat.service }}
    - enable: false
