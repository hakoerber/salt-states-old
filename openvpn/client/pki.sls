{% from 'openvpn/map.jinja' import openvpn with context %}
{% from 'openvpn/load_vpns.jinja' import vpns %}

{% for vpn in vpns %}

openvpn-keydir-{{ vpn.name }}:
  file.directory:
    - name: /etc/openvpn/keys-{{ vpn.name }}
    - user: root
    - group: root
    - mode: 700
    - watch_in:
      - service: openvpn-client-{{ vpn.name }}
    - require_in:
      - file: openvpn-client-{{ vpn.name }}.conf

openvpn-ca-cert-{{ vpn.name }}:
  file.managed:
    - name: /etc/openvpn/keys-{{ vpn.name }}/ca.crt
    - user: root
    - group: root
    - mode: 600
    - source: salt://openvpn/{{ vpn.name }}/shared/ca.crt
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-client-{{ vpn.name }}

openvpn-tls-auth-key-{{ vpn.name }}:
  file.managed:
    - name: /etc/openvpn/keys-{{ vpn.name }}/ta.key
    - user: root
    - group: root
    - mode: 600
    - source: salt://openvpn/{{ vpn.name }}/shared/ta.key
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-client-{{ vpn.name }}

{% set common_name = grains['id'] %}

openvpn-client-cert-{{ vpn.name }}:
  file.managed:
    - name: /etc/openvpn/keys-{{ vpn.name }}/client.crt
    - user: root
    - group: root
    - mode: 600
    - source: salt://openvpn/{{ vpn.name }}/clients/{{ common_name }}/{{ common_name }}.crt
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-client-{{ vpn.name }}

openvpn-client-key-{{ vpn.name }}:
  file.managed:
    - name: /etc/openvpn/keys-{{ vpn.name }}/client.key
    - user: root
    - group: root
    - mode: 600
    - source: salt://openvpn/{{ vpn.name }}/clients/{{ common_name }}/{{ common_name }}.key
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-client-{{ vpn.name }}
{% endfor %}
