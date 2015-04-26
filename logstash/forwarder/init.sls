{% from "logstash/map.jinja" import logstash with context %}

logstash-forwarder:
  pkg.installed:
    - name: {{ logstash.forwarder.package }}

  service.running:
    - name: {{ logstash.forwarder.service }}
    - enable: true
    - require:
      - pkg: logstash-forwarder
