{% from "nagios/check_mk/map.jinja" import check_mk with context %}

{% if grains['os_family'] == 'FreeBSD' %}
check-mk-agent-hosts-allow:
  file.append:
    - name: {{ check_mk.agent.conf.hosts_allow.path }}
    - text:
      - "check_mk_agent : mon.lab : allow"
      - "check_mk_agent : ALL : deny"
    - watch_in:
      - service: check-mk-agent-inetd

check-mk-agent-services:
  file.append:
    - name: {{ check_mk.agent.conf.services.path }}
    - text:
      - "check_mk 6556/tcp #check_mk agent"
    - watch_in:
      - service: check-mk-agent-inetd

check-mk-agent-inetd.conf:
  file.append:
    - name: {{ check_mk.agent.conf.inetd.path }}
    - text:
      - "check_mk  stream  tcp nowait  root  {{ check_mk.agent.script.path }} check_mk_agent"
    - watch_in:
      - service: check-mk-agent-inetd

check-mk-agent-inetd:
  service.running:
    - name: inetd
    - enable: true

{% else %}
check_mk-agent-xinetd-conf:
  file.managed:
    - name: {{ check_mk.agent.conf.xinetd.path }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: {{ check_mk.agent.conf.xinetd.template }}
    - template: jinja
    - require:
      - pkg: check_mk-agent
    - watch_in:
      - service: check_mk-agent
    - context:
      check_mk:
        server: mon.lab
{% endif %}
