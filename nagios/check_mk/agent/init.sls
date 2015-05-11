{% from "nagios/check_mk/map.jinja" import check_mk with context %}

{% if grains['os_family'] == 'FreeBSD' %}
check-mk-agent-script:
  file.managed:
    - name: {{ check_mk.agent.script.path }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 755
    - source: {{ check_mk.agent.script.source }}

{% else %}
check_mk-agent:
  pkg.installed:
    - name: {{ check_mk.agent.package }}

  service.running:
    - name: {{ check_mk.agent.service }}
    - enable: true
    - require:
      - pkg: check_mk-agent
{% endif %}
