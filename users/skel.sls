skel:
  file.recurse:
    - name: /etc/skel
    - user: root
    - group: {{ salt['pillar.get']('systemdefaults:root-group', 'root') }}
    - file_mode: 644
    - dir_mode: 755
    - source: salt://users/files/skel
