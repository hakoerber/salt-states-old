{% from 'openvpn/map.jinja' import openvpn with context %}
{% from 'openvpn/load_vpns.jinja' import vpns, vpns_authorative %}

{% for vpn in vpns_authorative %}

openvpn-keydir-{{ vpn.name }}:
  file.directory:
    - name: /etc/openvpn/keys-{{ vpn.name }}
    - user: root
    - group: root
    - mode: 700
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}
    - require_in:
      - file: openvpn-server-{{ vpn.name }}.conf

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
      - service: openvpn-server-{{ vpn.name }}

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
      - service: openvpn-server-{{ vpn.name }}

{% set common_name = grains['fqdn'] %}

openvpn-server-cert-{{ vpn.name }}:
  file.managed:
    - name: /etc/openvpn/keys-{{ vpn.name }}/server.crt
    - user: root
    - group: root
    - mode: 600
    - source: salt://openvpn/{{ vpn.name }}/server/server.crt
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}

openvpn-server-key-{{ vpn.name }}:
  file.managed:
    - name: /etc/openvpn/keys-{{ vpn.name }}/server.key
    - user: root
    - group: root
    - mode: 600
    - source: salt://openvpn/{{ vpn.name }}/server/server.key
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}

openvpn-server-dh-{{ vpn.name }}:
  file.managed:
    - name: /etc/openvpn/keys-{{ vpn.name }}/dh2048.pem
    - user: root
    - group: root
    - mode: 600
    - source: salt://openvpn/{{ vpn.name }}/server/dh2048.pem
    - show_diff: false
    - require:
      - file: openvpn-keydir-{{ vpn.name }}
    - watch_in:
      - service: openvpn-server-{{ vpn.name }}
