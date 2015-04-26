{% set families = ['ipv4', 'ipv6'] %}
{% set network = salt['pillar.get']('network') %}

{% for family in families %}
allow_output_{{ family }}:
  iptables.set_policy:
    - table: filter
    - chain: OUTPUT
    - policy: ACCEPT
    - family: {{ family }}
    - save: true

allow_input_{{ family }}:
  iptables.set_policy:
    - table: filter
    - chain: INPUT
    - policy: ACCEPT
    - family: {{ family }}
    - save: true

drop_forward_{{ family }}:
  iptables.set_policy:
    - table: filter
    - chain: FORWARD
    - policy: DROP
    - family: {{ family }}
    - save: true

chain_tcpudp_{{ family }}:
  iptables.chain_present:
    - name: TCPUDP
    - family: {{ family }}
    - save: true

chain_tcpudppublic_{{ family }}:
  iptables.chain_present:
    - name: TCPUDPPUBLIC
    - family: {{ family }}
    - save: true
    
chain_tcpudplocal_{{ family }}:
  iptables.chain_present:
    - name: TCPUDPLOCAL
    - family: {{ family }}
    - save: true
    
accept_loopback_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - family: {{ family }}
    - in-interface: lo
    - save: true

accept_related_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - family: {{ family }}
    - match: state
    - connstate: RELATED,ESTABLISHED
    - save: true

drop_invalid_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - family: {{ family }}
    - match: state
    - connstate: INVALID
    - save: true

{% endfor %}
accept_ping_ipv4:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - family: ipv4
    - proto: icmp
    - match: state
    - connstate: NEW
    - icmp-type: echo-request
    - save: true
    
accept_ping_ipv6:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - family: ipv6
    - proto: icmpv6
    - match: state
    - connstate: NEW
    - icmpv6-type: echo-request
    - save: true

accept_ndp_ipv6:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - family: ipv6
    - proto: icmpv6
    - source: fe80::/10
    - save: true

{% for family in families %}
tcp_jump_to_tcpudp_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: TCPUDP
    - family: {{ family }}
    - proto: tcp
    - tcp-flags: SYN,RST,ACK,FIN SYN
    - match: state
    - connstate: NEW
    - save: true

udp_jump_to_tcpudp_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: TCPUDP
    - family: {{ family }}
    - proto: udp
    - match: state
    - connstate: NEW
    - save: true

{% endfor %}
reject_tcp_gracefully_ipv4:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: tcp
    - family: ipv4
    - reject-with: tcp-reset
    - save: true

reject_tcp_gracefully_ipv6:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: tcp
    - family: ipv6
    - reject-with: icmp6-adm-prohibited
    - save: true

reject_udp_gracefully_ipv4:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: udp
    - family: ipv4
    - reject-with: icmp-port-unreachable
    - save: true

reject_udp_gracefully_ipv6:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: udp
    - family: ipv6
    - reject-with: icmp6-adm-prohibited
    - save: true

{% for family in families %}
drop_everything_else_{{ family }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - family: {{ family }}
    - save: true

tcpudp_redirect_public_{{ family }}:
  iptables.append:
    - table: filter
    - chain: TCPUDP
    - jump: TCPUDPPUBLIC
    - family: {{ family }}
    - save: true
{% endfor %}

tcpudp_redirect_local_ipv4:
  iptables.append:
    - table: filter
    - chain: TCPUDP
    - source: '{{ network.ip }}/{{ network.netmask }}'
    - jump: TCPUDPLOCAL
    - family: ipv4
    - save: true

{% for name, ip in salt['pillar.get']('network:localnets', {}).items() %}
tcpudp_redirect_local_ipv4_additional_localnet_{{ name }}:
  iptables.append:
    - table: filter
    - chain: TCPUDP
    - source: '{{ ip }}'
    - jump: TCPUDPLOCAL
    - family: ipv4
    - save: true
{% endfor %}



