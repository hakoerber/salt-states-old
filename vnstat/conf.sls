{% from "vnstat/map.jinja" import vnstat with context %}

include:
  - vnstat

vnstat.conf:
  file.managed:
    - name: {{ vnstat.conf_file }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: {{ vnstat.template }}
    - template: jinja
    - require:
      - pkg: vnstat
    - watch_in:
      - service: vnstat
    - defaults:
        vnstat: {{ vnstat }}

vnstat-group:
  group.present:
    - name: {{ vnstat.group }}
    - system: true

vnstat-user:
  user.present:
    - name: {{ vnstat.user }}
    - gid: {{ vnstat.group }}
    - system: true
    - home: {{ vnstat.home }}
    - shell: {{ vnstat.shell }}
    - createhome: false
    - require:
      - group: vnstat-group
