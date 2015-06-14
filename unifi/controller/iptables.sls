{% from 'unifi/map.jinja' import unifi with context %}

{% for name, ports in unifi.controller.ports.items() %}
{% for type, ports in ports.items() %}
unifi-iptables-{{ name }}-{{ type }}:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: {{ type }}
    - jump: ACCEPT
    - dports: {{ ports }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: unifi-controller-{{ name }}
{% endfor %}
{% endfor %}
