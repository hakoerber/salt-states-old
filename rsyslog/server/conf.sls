{% from 'rsyslog/map.jinja' import rsyslog with context %}

rsyslog.conf:
  file.managed:
    - name: {{ rsyslog.server.conf.file }} 
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

syslog-forward.conf:
  file.managed:
    - name: {{ rsyslog.server.conf.include }}/syslog-forward.conf
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: salt://rsyslog/files/syslog-forward.conf.jinja
    - template: jinja
    - defaults:
        rsyslog: {{ rsyslog }}
    - require:
      - pkg: rsyslog-server
    - watch_in:
      - service: rsyslog-server

