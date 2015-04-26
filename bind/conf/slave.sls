{% from "bind/map.jinja" import bind with context %}

{% set network = salt['pillar.get']('network') %}

{% set role = 'slave' %}

{% include "bind/conf/common.jinja" with context %}
