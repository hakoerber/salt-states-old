{% from 'openvpn/map.jinja' import openvpn with context %}
{% from 'openvpn/load_vpns.jinja' import vpns with context %}

openvpn-client:
  pkg.installed:
    - name: {{ openvpn.client.package }}

{% for vpn in vpns %}
openvpn-client-{{ vpn.name }}:
  service.running:
    {% if '%s' in openvpn.client.service %}
    - name: {{ openvpn.client.service|format('client-' + vpn.name) }}
    {% else %}
    - name: {{ openvpn.client.service }}
    {% endif %}
     
    - enable: true
    - require:
      - pkg: openvpn-client
{% endfor %}
