{% from 'openvpn/map.jinja' import openvpn with context %}
{% from 'openvpn/load_vpns.jinja' import vpns, vpns_authorative %}

{% for vpn in vpns_authorative %}
openvpn-server-{{ vpn.name }}.conf:
  file.managed:
    - name: /etc/openvpn/server-{{ vpn.name }}.conf
    - user: root
    - group: root
    - mode: 644
    - source: salt://openvpn/files/server.conf.jinja
    - template: jinja
    - require:
      - pkg: openvpn-server
    - context:
      openvpn: {{ openvpn }}
      vpn: {{ vpn }}
      nobody: {{ salt['pillar.get']('systemdefaults:nobody') }}
      nogroup: {{ salt['pillar.get']('systemdefaults:nogroup') }}
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}
    - require:
      - file: openvpn-server-{{ vpn.name }}-ccd

openvpn-server-{{ vpn.name }}-ccd:
  file.directory:
    - name: /etc/openvpn/ccd-{{ vpn.name }}
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: openvpn-server

{% set chain = 'VPN_' + vpn.name|upper %}

openvpn-chain-vpn-{{ vpn.name }}:
  iptables.chain_present:
    - name: {{ chain }}

openvpn-jump_forward_inward_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - in-interface: {{ vpn.devname }}
    - jump: {{ chain }}
    - save: true

openvpn-jump_forward_outward_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - out-interface: {{ vpn.devname }}
    - jump: {{ chain }}
    - save: true

openvpn-allow_forward_all_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - save: true

{% for name, conf in vpn.clients.items() %}
{% if conf.ip != 'dhcp' or conf.advertise_subnet is defined %}
openvpn-server-{{ vpn.name }}-ccd-{{ name }}:
  file.managed:
    - name: /etc/openvpn/ccd-{{ vpn.name }}/{{ name }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://openvpn/files/server.ccd.jinja
    - template: jinja
    - context:
      client_conf: {{ conf }}
      vpn: {{ vpn }}
    - require:
      - file: openvpn-server-{{ vpn.name }}-ccd
      - pkg: openvpn-server

{% endif %}
{% endfor %}

{% endfor %}
