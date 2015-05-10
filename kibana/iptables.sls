{% from 'kibana/map.jinja' import kibana with context %}

kibana-iptables:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ kibana.port }}
    - family: ipv4
    - save: true
    - match: comment 
    - comment: kibana
