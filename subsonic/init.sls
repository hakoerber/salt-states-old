{% from "subsonic/map.jinja" import subsonic with context %}

openjdk:
  pkg.installed:
    - name: {{ subsonic.dependencies.java }}

subsonic:
  pkg.installed:
    - sources: 
      - {{ subsonic.package.name }}: {{ subsonic.package.url }}
    - allow_updates: false
    - require:
      - pkg: openjdk

  service.running:
    - name: {{ subsonic.service }}
    - enable: true
    - require:
      - pkg: subsonic
