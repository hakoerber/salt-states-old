#!stateconf -G
{% from 'rsyslog/map.jinja' import rsyslog with context %}

.sls_params:
  stateconf.set: []

# --- end of state config ---

.rsyslog-app:
  file.managed:
    - name: {{ rsyslog.client.include_basedir }}/{{ sls_params.application }}.conf
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: salt://rsyslog/files/applications.conf.jinja
    - template: jinja
    - defaults:
        rsyslog: {{ rsyslog }}
        application: {{ sls_params.application }}
        files: {{ sls_params.files }}
    - require:
      - pkg: rsyslog-client
      - file: rsyslog.d
    - watch_in:
      - service: rsyslog-client
