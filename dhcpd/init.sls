{% from "dhcpd/map.jinja" import dhcpd with context %}

dhcpd:
  pkg.installed:
    - name: {{ dhcpd.package }}

  service.running:
    - name: {{ dhcpd.service }}
    - enable: true
    - require:
      - pkg: dhcpd
