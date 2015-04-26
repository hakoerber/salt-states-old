{% from "zabbix/map.jinja" import zabbix with context %}

zabbix-agent:
  pkg.installed:
    - name: {{ zabbix.agent.package }}

  service.running:
    - name: {{ zabbix.agent.service }}
    - enable: true
    - require:
      - pkg: zabbix-agent
