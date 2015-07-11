{% from 'foreman/map.jinja' import foreman with context %}

{% for name, rule in foreman.ports.items() %}
{% for proto, ports in rule.items() %}
foreman-iptables-{{ name }}-{{ proto }}:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: {{ proto }}
    - jump: ACCEPT
    - dports: {{ ports }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: foreman-{{ name }}
{% endfor %}
{% endfor %}
