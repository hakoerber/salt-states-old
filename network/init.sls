{% if grains['os_family'] == 'RedHat' %}

{% set network = salt['pillar.get']('network') %}
{% set hostname = grains['host'] %}
{% set hostconfig = network.hosts.get(hostname, None) %}

{% if hostconfig != None %}
{% set ifconfig = hostconfig.get('ifconfig', {}) %}
{% for ifname, ifsettings in ifconfig.items() %}
{% if ifconfig != 'none' %}
if-{{ ifname }}:
  network.managed:
    - name: {{ ifname }}
    - type: {{ ifsettings.type }}
    - enabled: true
    - hwaddr: {{ hostconfig.mac }}
    - userctl: no
    {% if ifsettings.mode == 'dhcp' %}
    - proto: dhcp
    # this does not work right now, the state module just ignores settings
    # it does not recognize
    - persistent_dhclient: yes
    - peerntp: no
    {% elif ifsettings.mode == 'static' %}
    - ipaddr: {{ hostconfig.ip[0] }}
    - netmask: {{ network.netmask }}
    - gateway: {{ network.gateway }}

    - dns:
      {% if ifsettings.dns is defined %}
      {% for dnsserver in ifsettings.dns %}
      - {{ dnsserver }}
      {% endfor %}
      {% else %}
      - {{ network.dns.masterdns.ip }}
      - {{ network.dns.slavedns.ip }}
      {% endif %}
    {% endif %}
{% endif %}
{% endfor %}
{% endif %}

{% endif %}
