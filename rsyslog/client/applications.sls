{% from 'rsyslog/map.jinja' import rsyslog with context %}

{% set applications = salt['pillar.get']("logging:applications") %}

{% for application, files in applications.items() %}
rsyslog-{{ application }}.conf:
  file.managed:
    - name: {{ rsyslog.client.include_basedir }}/{{ application }}.conf
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: salt://rsyslog/files/applications.conf.jinja
    - template: jinja
    - defaults:
        rsyslog: {{ rsyslog }}
        application: {{ application }}
        files: {{ files }}
    - require:
      - pkg: rsyslog-client
      - file: rsyslog.d
    - watch_in:
      - service: rsyslog-client
{% endfor %}
