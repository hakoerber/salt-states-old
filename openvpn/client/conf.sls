{% from 'openvpn/map.jinja' import openvpn with context %}
{% from 'openvpn/load_vpns.jinja' import vpns %}

{% for vpn in vpns %}
openvpn-client-{{ vpn.name }}.conf:
  file.managed:
    - name: /etc/openvpn/client-{{ vpn.name }}.conf
    - user: root
    - group: root
    - mode: 644
    - source: salt://openvpn/files/client.conf.jinja
    - template: jinja
    - require:
      - pkg: openvpn-client
    - context:
      openvpn: {{ openvpn }}
      vpn: {{ vpn }}
      nobody: {{ salt['pillar.get']('systemdefaults:nobody') }}
      nogroup: {{ salt['pillar.get']('systemdefaults:nogroup') }}
    - watch_in:
      - service: openvpn-client-{{ vpn.name }}
{% endfor %}
