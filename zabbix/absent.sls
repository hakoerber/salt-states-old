{% from "zabbix/map.jinja" import zabbix with context %}

zabbix-agent-absent:
  pkg.removed:
    - name: {{ zabbix.agent.package }}
    - require:
      - service: vnstat

  service.dead:
    - name: {{ zabbix.agent.service }}
    - enable: false
