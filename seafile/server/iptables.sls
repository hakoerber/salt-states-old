{% from 'seafile/map.jinja' import seafile with context %}

{% for name, ports in seafile.ports.items() %}
seafile_iptables-{{ name }}:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ ports }}
    - family: ipv4
    - save: true
    - match: comment 
    - comment: seafile-{{ name }}
{% endfor %}
