{% from "rsyslog/map.jinja" import rsyslog with context %}

rsyslog-server:
  pkg.installed:
    - name: {{ rsyslog.server.package }}

  service.running:
    - name: {{ rsyslog.server.service }}
    - enable: true
    - require:
      - pkg: rsyslog-server
