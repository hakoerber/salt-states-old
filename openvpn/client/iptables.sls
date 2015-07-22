{% from 'openvpn/map.jinja' import openvpn with context %}
{% from 'openvpn/load_vpns.jinja' import vpns %}

{% for vpn in vpns %}

{% set chain = 'VPN_' + vpn.name|upper %}

chain_vpn_{{ vpn.name }}:
  iptables.chain_present:
    - name: {{ chain }}

jump_forward_inward_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - in-interface: {{ vpn.devname }}
    - jump: {{ chain }}
    - save: true

jump_forward_outward_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - out-interface: {{ vpn.devname }}
    - jump: {{ chain }}
    - save: true

{% if vpn.config.get('allow_forward', None) == 'all' %}
allow_forward_all_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - save: true
{% elif vpn.config.allow_forward is defined %}

{% if not vpn.config.get('allow_access', False) %}
deny_client_access_vpn_{{ vpn.name }}:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: INPUT
    - in-interface: {{ vpn.devname }}
    - jump: REJECT
    - save: true
{% endif %}

allow_selective_forward_inward_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - destination: {{ vpn.config.allow_forward|join(',') }}
    - save: true
    
allow_selective_forward_outward_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - source: {{ vpn.config.allow_forward|join(',') }}
    - save: true

deny_forward_vpn_{{ vpn.name }}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: REJECT
    - save: true
{% endif %}

{% endfor %}
