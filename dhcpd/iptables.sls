{% from "dhcpd/map.jinja" import dhcpd with context %}
{% set network = salt['pillar.get']('network') %}

include:
  - dhcpd

dhcpd-iptables-ipv4:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: udp
    - jump: ACCEPT
    - dport: 67
    - family: ipv4 
    - save: true
    - match: comment
    - comment: DHCP server

