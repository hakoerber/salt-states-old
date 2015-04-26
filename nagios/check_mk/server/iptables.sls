{% from 'nagios/check_mk/map.jinja' import check_mk with context %}

check_mk-server-iptables:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ check_mk.server.port }}
    - family: ipv4
    - save: true
    - match: comment 
    - comment: check_mk-server
