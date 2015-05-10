{% from 'rsyslog/map.jinja' import rsyslog with context %}

rsyslog.conf:
  file.managed:
    - name: {{ rsyslog.client.conf }} 
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: salt://rsyslog/files/rsyslog.client.conf.jinja
    - template: jinja
    - defaults:
        rsyslog: {{ rsyslog }}
    - require:
      - pkg: rsyslog-client
    - watch_in:
      - service: rsyslog-client

{% for file in rsyslog.client.include %}


{{ file }}:
  file.managed:
    - name: {{ rsyslog.client.include_basedir }}/{{ file }}
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: salt://rsyslog/files/{{ file }}.jinja
    - template: jinja
    - defaults:
        rsyslog: {{ rsyslog }}
        network: {{ salt['pillar.get']('network') }}
    - require:
      - pkg: rsyslog-client
    - watch_in:
      - service: rsyslog-client
{% endfor %}

