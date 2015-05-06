{% for user, userinfo in pillar['users'].items() %}
{% set rootgroup = salt['pillar.get']('systemdefaults:root-group', 'root') %}

{% for group in userinfo.get('groups', []) %}
group-{{ group }}:
  group.present:
    - name: {{ group }}
    - system: true
{% endfor %}

user-{{ user }}:
  group.present:
    {% if user == 'root' %}
    - name: {{ rootgroup }}
    {% else %}
    - name: {{ user }}
    {% endif %}
    - gid: {{ userinfo.uid }}

  user.present:
    - name: {{ user }}
    - uid: {{ userinfo.uid }}
    {% if user == 'root' %}
    - gid: {{ rootgroup }}
    {% else %}
    - gid_from_name: true
    {% endif %}
    - shell: {{ userinfo.shell }}
    - home: {{ userinfo.home }}
    - createhome: true
    - password: {{ userinfo.password }}
    {% if userinfo.groups is defined %}
    - groups: {{ userinfo.groups }}
    - remove_groups: false
    {% else %}
    - remove_groups: false
    {% endif %}
    - require:
      {% if user == 'root' %}
      - group: {{ rootgroup }}
      {% else %}
      - group: {{ user }}
      {% endif %}
      {% for group in userinfo.get('groups', []) %}
      - group: {{ group }} 
      {% endfor %}

{% if userinfo.get('ssh_client') %}
home-ssh-dir-{{ user }}:
  file.directory:
    - name: {{ userinfo.home }}/.ssh
    - user: {{ user }}
    - group: {{ user }}
    - mode: 700

{% for keytype in userinfo.ssh_key_types %}
{% for ext in ['', '.pub'] %}
ssh-key-{{ keytype }}-{{ ext|replace('.', '') }}-{{ user }}:
  file.managed:
    - name: {{ userinfo.home }}/.ssh/id_{{ keytype }}{{ ext }}
    - mode: 600
    - follow_symlinks: false
    - user: {{ user }}
    - group: {{ user }}
    - source: salt://users/{{ user }}/ssh/id_{{ keytype }}{{ ext }}
    - require:
      - file: home-ssh-dir-{{ user }}
{% endfor %}
{% endfor %}

{% for user in userinfo.ssh_allowed_users %}
authorized-keys-{{ user }}:
  ssh_auth.present:
    - user: {{ user }}
    - enc: ssh-rsa
    - comment: {{ user }}
    - source: salt://users/{{ user }}/ssh/id_rsa.pub
{% endfor %}
{% endif %}

{% endfor %}
