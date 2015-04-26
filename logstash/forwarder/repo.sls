{% if grains['os'] == 'CentOS' %}
logstash-forwarder-repo:
  pkgrepo.managed:
    - humanname: logstash-forwarder repository
    - baseurl: http://packages.elasticsearch.org/logstashforwarder/centos
    - gpgcheck: 1
    - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - require_in:
      - pkg: logstash-forwarder

{% elif grains['os'] == 'Debian' %}
logstash-forwarder-repo:
  pkgrepo.managed:
    - humanname: logstash-forwarder repository
    

    - name: deb http://packages.elasticsearch.org/logstashforwarder/debian stable main
    - file: /etc/apt/sources.list.d/logstash.list
    - require_in:
        - pkg: logstash-forwarder
#   - require:
#     - cmd: logstash-forwarder-repo
#
#   cmd.run:
#     - name: wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
##     - creates:
{% endif %}

