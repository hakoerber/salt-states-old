{% from "bind/map.jinja" import bind with context %}

include:
  - bind

{% for family in ['ipv4'] %}
{% for proto in ['tcp', 'udp'] %}
bind-iptables-{{ family }}-{{ proto }}:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: {{ proto }}
    - jump: ACCEPT
    - dport: 53
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: BIND DNS server
{% endfor %}
{% endfor %}

