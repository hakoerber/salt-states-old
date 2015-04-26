{% if grains['os_family'] == 'RedHat' %}
epel:
  pkg.installed:
    - name: epel-release
    - order: 0
{% endif %}
