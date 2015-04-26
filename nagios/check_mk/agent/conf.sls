{% from "nagios/check_mk/map.jinja" import check_mk with context %}

check_mk-agent-xinetd-conf:
  file.managed:
    - name: {{ check_mk.agent.conf.xinetd.path }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: {{ check_mk.agent.conf.xinetd.template }}
    - template: jinja
    - require:
      - pkg: check_mk-agent
    - watch_in:
      - service: check_mk-agent
    - context:
      check_mk:
        server: mon.lab
