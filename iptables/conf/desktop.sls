{% for family in ['ipv4', 'ipv6'] %}
allow_output_{{ family }}:
  iptables.set_policy:
    - table: filter
    - chain: OUTPUT
    - policy: ACCEPT
    - family: {{ family }}

allow_input_{{ family }}:
  iptables.set_policy:
    - table: filter
    - chain: INPUT
    - policy: ACCEPT
    - family: {{ family }}
    
drop_forward_{{ family }}:
  iptables.set_policy:
    - table: filter
    - chain: FORWARD
    - policy: DROP
    - family: {{ family }}
{% endfor %}
