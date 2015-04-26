{% from "bind/map.jinja" import bind with context %}

{% set zone_forward_template = 'salt://bind/files/forward.zone.jinja' %}
{% set zone_reverse_template = 'salt://bind/files/reverse.zone.jinja' %}

{% set network = salt['pillar.get']('network') %}

{% set role = 'master' %}

{% include "bind/conf/common.jinja" with context %}

reload_zones:
  cmd.wait:
    - name: rndc reload

zone-{{ network.domain }}-forward:
  file.managed:
    - name: {{ bind.main_directory }}/forward.{{ network.domain }}
    - user: root
    - group: root
    - mode: 644
    - source: {{ zone_forward_template }}
    - template: jinja
    - defaults:
        zonename: {{ network.domain }}
        nameservers: {{ network.nameservers }}
        zone: {{ network.dns }}
        records: {{ network.hosts }}
    - require:
      - pkg: bind
    - watch_in:
      - cmd: reload_zones

zone-{{ network.domain }}-reverse:
  file.managed:
    - name: {{ bind.main_directory }}/reverse.{{ network.domain }}
    - user: root
    - group: root
    - mode: 644
    - source: {{ zone_reverse_template }}
    - template: jinja
    - defaults:
        zonename: {{ network.domain }}
        nameservers: {{ network.nameservers }}
        zone: {{ network.dns }}
        records: {{ network.hosts }}
    - require:
      - pkg: bind
    - watch_in:
      - cmd: reload_zones
