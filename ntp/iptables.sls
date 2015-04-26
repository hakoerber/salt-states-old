{% from "ntp/map.jinja" import ntp with context %}

include:
  - ntp

{% for family in ['ipv4'] %}
ntp-iptables-{{ family }}-udp:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: udp
    - jump: ACCEPT
    - dport: 123
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: NTP Server
{% endfor %}

