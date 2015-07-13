{% from 'nginx/map.jinja' import nginx with context %}

nginx:
  pkg.installed:
    - name: {{ nginx.package }}

  service.running:
    - name: {{ nginx.service }}
    - enable: true
    - require:
      - pkg: nginx
