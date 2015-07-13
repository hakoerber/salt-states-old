{% from 'nginx/map.jinja' import nginx with context %}

{% if pillar.get('nginx', {}).get('use_http', False) %}
nginx-iptables-http:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ nginx.ports.http }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: nginx-http
{% endif %}

{% if pillar.get('nginx', {}).get('use_http', False) %}
nginx-iptables-https:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ nginx.ports.https }}
    - family: ipv4
    - save: true
    - match: comment
    - comment: nginx-https
{% endif %}
