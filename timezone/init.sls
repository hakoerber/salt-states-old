# timedatectl cannot be parsed (thank you systemd)
{% if grains['os'] != 'CentOS' and salt['grains.get']('osmajorrelease', 0) != 7 %}
timezone:
  timezone.system:
    - name: Europe/Berlin
    - utc: true
{% endif %}
