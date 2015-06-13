{% from "logstash/map.jinja" import logstash with context %}

logstash-forwarder:
  pkg.removed:
    - name: {{ logstash.forwarder.package }}
    - onlyif:
      - pkgrepo: logstash-forwarder-repo

  service.dead:
    - name: {{ logstash.forwarder.service }}
    - enable: false
    - require:
      - pkg: logstash-forwarder

logstash-forwarder-repo:
  pkgrepo.absent:
    {% if grains['os'] == 'CentOS' %}
    - name: logstash-forwarder-repo
    {% elif grains['os'] == 'Debian' %}
    - name: deb http://packages.elasticsearch.org/logstashforwarder/debian stable main
    {% endif %}
