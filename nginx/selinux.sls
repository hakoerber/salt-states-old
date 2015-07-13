{% if pillar.nginx.proxy is defined and pillar.nginx.proxy.targets is defined %}
nginx-selinux-httpd_can_network_connect:
  selinux.boolean:
    - name: httpd_can_network_connect
    - value: on
    - persist: True
{% endif %}

