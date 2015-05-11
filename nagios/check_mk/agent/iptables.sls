{% from 'nagios/check_mk/map.jinja' import check_mk with context %}

{% if grains['os_family'] != 'FreeBSD' %}
check_mk-agent-iptables:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ check_mk.agent.port }}
    - family: ipv4
    - save: true
    - match: comment 
    - comment: check_mk-agent
{% endif %}
