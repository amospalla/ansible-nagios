Ansible role for Nagios setup

Sample playbook:
---
# Provided a list like:
# ---
# nagios_rbl_ip_list:
#   - normal_check_interval: 1440 (minutes)
#     address:
#       - x.x.x.x/y
#   - normal_check_interval: 1440 (minutes)
#     address:
#       - x.x.x.x
# this generates a yaml vars file which contains the variables for Nagios rbl
# check plugin. This file should be saved onto the Ansible inventory folder
# structure.
# Note that this doesn't mean the role is configuring this host as a Nagios
# server, just because it won't have the hostvar nagios_server=True
- hosts: ansible.hostname
  roles:
    - role: nagios
      rbl_ip_list_create: true
      rbl_ip_list_path: /path/to/inventory/vars/nagios_rbl_ip_list
      rbl_ip_list_owner: user running ansible

# Nagios server is installed on the host with hostvar nagios_server=True.
# role_prefix: nrpe checks and nrpe commands file are prefixed with this string.
- hosts: linux
  roles:
    - role: nagios
      role_prefix: optional
