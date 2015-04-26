{% from "vnstat/map.jinja" import vnstat with context %}

vnstat:
  pkg.installed:
    - name: {{ vnstat.package }}

  service.running:
    - name: {{ vnstat.service }}
    - enable: true
    - require:
      - pkg: vnstat
