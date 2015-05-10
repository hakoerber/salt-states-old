{% from 'rsyslog/map.jinja' import rsyslog with context %}

rsyslog-iptables:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ rsyslog.server.listen.port }}
    - family: ipv4
    - save: true
    - match: comment 
    - comment: rsyslog-server
