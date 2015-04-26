{% from 'zabbix/map.jinja' import zabbix with context %}

zabbix_iptables:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ zabbix.agent.port }}
    - family: ipv4
    - save: true
    - match: comment 
    - comment: zabbix-agent
