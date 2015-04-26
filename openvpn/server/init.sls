{% from 'openvpn/map.jinja' import openvpn with context %}
{% from 'openvpn/load_vpns.jinja' import vpns, vpns_authorative with context %}

openvpn-server:
  pkg.installed:
    - name: {{ openvpn.server.package }}

{% for vpn in vpns_authorative %}
openvpn-server-{{ vpn.name }}:
  service.running:
    {% if '%s' in openvpn.server.service %}
    - name: {{ openvpn.server.service|format('server-' + vpn.name) }}
    {% else %}
    - name: {{ openvpn.server.service }}
    {% endif %}
     
    - enable: true
    - require:
      - pkg: openvpn-server
{% endfor %}
