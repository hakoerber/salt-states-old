{% from 'subsonic/map.jinja' import subsonic with context %}

subsonic_iptables:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ subsonic.ports.tcp }}
    - family: ipv4
    - save: true
    - match: comment 
    - comment: subsonic-web
