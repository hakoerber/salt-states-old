{% from "rsyslog/map.jinja" import rsyslog with context %}

rsyslog-client:
  pkg.installed:
    - name: {{ rsyslog.client.package }}

  service.running:
    - name: {{ rsyslog.client.service }}
    - enable: true
    - require:
      - pkg: rsyslog-client
