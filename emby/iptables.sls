{% from 'emby/map.jinja' import emby with context %}

emby_iptables:
  iptables.append:
    - table: filter
    - chain: TCPUDPLOCAL
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ emby.ports.tcp }}
    - family: ipv4
    - save: true
    - match: comment 
    - comment: emby-web
