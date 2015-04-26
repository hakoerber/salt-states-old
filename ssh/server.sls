{% from 'ssh/map.jinja' import ssh with context %}

ssh-server:
  {% if ssh.server.package != None %}
  pkg.installed:
    - name: {{ ssh.server.package }}
    - require_in:
      - service: ssh-server
      - file: sshd_config
  {% endif %}

  service.running:
    - name: {{ ssh.server.service }}
    - enable: true
    - watch:
      - file: sshd_config

{% if grains['os_family'] != 'FreeBSD' %}
{% for family in ['ipv4', 'ipv6'] %}
ssh-server-iptables-{{ family }}:
  iptables.append:
    - table: filter
    - chain: TCPUDPPUBLIC
    - proto: tcp
    - jump: ACCEPT
    - dports: {{ ssh.server.ports }}
    - family: {{ family }}
    - save: true
    - match: comment
    - comment: ssh-server
{% endfor %}
{% endif %}

{% for keytype in ssh.server.default_keytypes %}
hostkey-{{ keytype }}:
  file.managed:
    - name: /etc/ssh/ssh_host_{{ keytype }}_key
    - mode: 600
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - source: salt://ssh/hostkeys/{{ grains['id'] }}/ssh_host_{{ keytype }}_key
    - show_diff: false

hostkey-{{ keytype }}-pub:
  file.managed:
    - name: /etc/ssh/ssh_host_{{ keytype }}_key.pub
    - mode: 644
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - source: salt://ssh/hostkeys/{{ grains['id'] }}//ssh_host_{{ keytype }}_key.pub
    - show_diff: false
{% endfor %}

sshd_config:
  file.managed:
    - name: {{ ssh.server.conf_file }}
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - mode: 644
    - source: salt://ssh/files/sshd_config.jinja
    - template: jinja
    - context:
      ports: {{ ssh.server.ports }}
      sftp_binary: {{ ssh.server.sftp_binary }}
      keytypes: {{ ssh.server.default_keytypes }}
