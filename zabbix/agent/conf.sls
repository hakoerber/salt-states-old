{% from "zabbix/map.jinja" import zabbix with context %}

zabbix_agentd.conf:
  file.managed:
    - name: {{ zabbix.agent.conf.path }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: {{ zabbix.agent.conf.template }}
    - template: jinja
    - require:
      - pkg: zabbix-agent
        directory: zabbix_local_dir
    - watch_in:
      - service: zabbix-agent
    - context:
      zabbix:
        server: mon.lab

zabbix_local_dir:
  file.directory:
    - name: /usr/local/etc/zabbix_agentd.conf.d
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 755
    - require_in:
      - service: zabbix-agent
