Role Name
=========

This role download certs generated with Sophos Astaro v9 (ASG9) also letsencrypt certs. The certs to download should be specified in _cert_names_ with the same name showed in the ASG webAdmin. As default, the certificates will downloaded at /tmp/asg-certs in the execution path but it can be changed via _download_path_ variable.

Requirements
------------

You will need _jmespath_ python lib, to install:

```
pip install jmespath 
```

Role Variables
--------------

- **asg_url**: ASG9 url
- **download_path(optional):** Path to download certs, default value _/tmp/asg-certs_
- **vault_asg_user:** ASG user api authentication (you can't use admin)
- **vault_asg_user_password:** ASG user api user password
- **cert_names:** List of certs to download

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
---
- name: ASG Certs Download
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    asg_url: https://my_sophos_url:4444
    vault_asg_user: my_asg_user
    vault_asg_user_password: my_asg_pass
    download_path: /tmp/my_certs
    certs:
      - my.site1.com
      - intranet
      - my_other_cert

  roles:
    - asg

  tasks:
```