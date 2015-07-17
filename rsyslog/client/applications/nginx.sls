#!stateconf -G
{% set name = 'nginx' %}

{% from 'rsyslog/map.jinja' import rsyslog with context %}
{% set files = rsyslog.client.applications.get(name, {}) %}

include:
  - .generic

extend:
  .generic::sls_params:
    stateconf.set:
      - application: {{ name }}
      - files: {{ files }}
