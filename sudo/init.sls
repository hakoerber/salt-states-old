{% from 'sudo/map.jinja' import sudo with context %}

sudo:
  pkg.installed:
    - name: {{ sudo.package }}

sudoers:
  file.managed:
    - name: {{ sudo.sudoers }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 600
    - source: salt://sudo/files/sudoers
    - require:
      - pkg: sudo

