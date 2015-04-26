{% from 'iptables/map.jinja' import iptables with context %}

iptables:
  pkg.installed:
    # this is better than requiring this package in every iptables state
    - order: 1
    - pkgs: {{ iptables.packages }}


{% for service in iptables.services %}
{{ service }}-service:
  service.running:
    - name: {{ service }}
    - enable: true
    - require:
      - pkg: iptables
{% endfor %}

