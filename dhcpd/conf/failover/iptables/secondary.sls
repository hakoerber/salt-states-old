{% from "dhcpd/map.jinja" import dhcpd with context %}
{% set network = salt['pillar.get']('network') %}

include:
  - dhcpd.conf.failover

{% set failover_mode = "secondary" %}

{% if failover_mode == "primary" %}
{% set peer_ip = network.hosts.get(network.dhcp.failover.secondary.name).ip[0] %}
{% else %}
{% set peer_ip = network.hosts.get(network.dhcp.failover.primary.name).ip[0] %}
{% endif %}

dhcpd-iptables-ipv4-failover:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - source: {{ peer_ip }}
    - dport: 647
    - family: ipv4 
    - save: true
    - match: comment
    - comment: DHCP server failover

