{% from 'nginx/map.jinja' import nginx with context %}

nginx.conf:
  file.managed:
    - name: {{ nginx.conf.main_path }}
    - user: root
    - group: root
    - mode: 644
    - source: {{ nginx.conf.main_template }}
    - template: jinja
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

nginx-conf.d:
  file.directory:
    - name: {{ nginx.conf.include_dir }}
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: nginx

{% if pillar.nginx.content is defined %}
nginx-05_content.conf:
  file.managed:
    - name: {{ nginx.conf.include_dir }}/05_content.conf
    - user: root
    - group: root
    - mode: 644
    - source: {{ nginx.conf.template_dir }}/05_content.conf.jinja
    - template: jinja
    - context:
      content: {{ pillar.nginx.content }}
    - require:
      - pkg: nginx
      - file: nginx-conf.d
    - watch_in:
      - service: nginx
{% endif %}

{% if pillar.nginx.proxy is defined %}
nginx-20_proxy.conf:
  file.managed:
    - name: {{ nginx.conf.include_dir }}/20_proxy.conf
    - user: root
    - group: root
    - mode: 644
    - source: {{ nginx.conf.template_dir }}/20_proxy.conf.jinja
    - template: jinja
    - context:
      proxy_conf: {{ pillar.nginx.proxy }}
    - require:
      - pkg: nginx
      - file: nginx-conf.d
    - watch_in:
      - service: nginx
{% endif %}

{% if pillar.nginx.get('force_https', False) %}
nginx-10_force_https.conf:
  file.managed:
    - name: {{ nginx.conf.include_dir }}/10_force_https.conf
    - user: root
    - group: root
    - mode: 644
    - source: {{ nginx.conf.template_dir }}/10_force_https.conf.jinja
    - template: jinja
    - require:
      - pkg: nginx
      - file: nginx-conf.d
    - watch_in:
      - service: nginx
{% endif %}

{% if pillar.nginx.get('use_https', False) %}
nginx-15_ssl.conf:
  file.managed:
    - name: {{ nginx.conf.include_dir }}/15_ssl.conf
    - user: root
    - group: root
    - mode: 644
    - source: {{ nginx.conf.template_dir }}/15_ssl.conf.jinja
    - template: jinja
    - require:
      - pkg: nginx
      - file: nginx-conf.d
    - watch_in:
      - service: nginx
{% endif %}
