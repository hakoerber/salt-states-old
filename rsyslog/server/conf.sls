{% from 'rsyslog/map.jinja' import rsyslog with context %}

rsyslog.conf:
  file.managed:
    - name: {{ rsyslog.server.conf }} 
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: salt://rsyslog/files/rsyslog.server.conf.jinja
    - template: jinja
    - defaults:
        rsyslog: {{ rsyslog }}
    - require:
      - pkg: rsyslog-server
    - watch_in:
      - service: rsyslog-server

rsyslog.d:
  file.directory:
    - name: {{ rsyslog.client.include_basedir }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 755

{% for file in rsyslog.server.include %}
{{ file }}:
  file.managed:
    - name: {{ rsyslog.server.include_basedir }}/{{ file }}
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: salt://rsyslog/files/{{ file }}.jinja
    - template: jinja
    - defaults:
        rsyslog: {{ rsyslog }}
        network: {{ salt['pillar.get']('network') }}
    - require:
      - pkg: rsyslog-server
    - watch_in:
      - service: rsyslog-server
{% endfor %}
