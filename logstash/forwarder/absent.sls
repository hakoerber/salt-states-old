{% from "logstash/map.jinja" import logstash with context %}

logstash-forwarder:
  pkg.removed:
    - name: {{ logstash.forwarder.package }}

  service.dead:
    - name: {{ logstash.forwarder.service }}
    - enable: false
    - require:
      - pkg: logstash-forwarder
