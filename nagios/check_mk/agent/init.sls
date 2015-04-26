{% from "nagios/check_mk/map.jinja" import check_mk with context %}

check_mk-agent:
  pkg.installed:
    - name: {{ check_mk.agent.package }}

  service.running:
    - name: {{ check_mk.agent.service }}
    - enable: true
    - require:
      - pkg: check_mk-agent
