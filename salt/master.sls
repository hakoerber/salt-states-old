{% from 'salt/map.jinja' import saltmap with context %}

salt-master:
  service.running:
    - name: {{ saltmap.master.service }}
    - enable: true
    - watch:
      - file: salt-master-conf
 
  iptables.append:
    - table: filter
    - chain: TCPUDP
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ saltmap.master.ports }}
    - family: ipv4
    - save: true
    - match: comment 
    - comment: salt-master

salt-master-conf:
  file.managed:
    - name: {{ saltmap.master.conf_file }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 600
    - source: salt://salt/files/master
