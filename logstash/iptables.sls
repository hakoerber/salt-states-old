{% from "logstash/map.jinja" import logstash with context %}

logstash-server-iptables:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - dport: {{ logstash.forwarder.port }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: Logstash server
