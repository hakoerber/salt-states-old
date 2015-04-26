{% from 'logstash/map.jinja' import logstash with context %}

logstash-forwarder.crt:
  file.managed:
    - name: {{ logstash.pki.cert }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 600
    - source: {{ logstash.pki.source }}
    - show_diff: false
    - watch_in:
      - service: logstash-forwarder

