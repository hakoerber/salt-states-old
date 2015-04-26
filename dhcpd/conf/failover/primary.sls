{% from "dhcpd/map.jinja" import dhcpd with context %}
{% set conf_template = 'salt://dhcpd/files/dhcpd.conf.jinja' %}
{% set network = salt['pillar.get']('network') %}

include:
  - dhcpd

dhcpd.conf:
  file.managed:
    - name: {{ dhcpd.conf_file }}
    - user: root
    - group: root
    - mode: 644
    - source: {{ conf_template }}
    - template: jinja
    - require:
      - pkg: dhcpd
    - watch_in:
      - service: dhcpd
    - defaults: 
        failover_mode: "primary"
        network: {{ network }}



