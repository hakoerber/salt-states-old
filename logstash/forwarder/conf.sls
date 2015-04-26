{% from 'logstash/map.jinja' import logstash with context %}

logstash-forwarder.conf:
  file.managed:
    - name: {{ logstash.forwarder.conf.file }} 
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: salt://logstash/files/logstash-forwarder.conf.jinja
    - template: jinja
    - defaults:
        logstash: {{ logstash }}
        network: {{ salt['pillar.get']('network') }}
    - require:
      - pkg: logstash-forwarder
    - watch_in:
      - service: logstash-forwarder
