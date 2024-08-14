## Variable definition for global users (all variable group scope)

```
global_users:
  user_1:
    groups: ["my_global_group_1","my_global_group_2", "sudo"]
  user_2:
    groups: ["my_group_2"]

global_groups:
  - my_global_group_1
  - my_global_group_2
```


## Variable definition for group server users 
group_vars/all.yaml file

```
group_users:
  user_3:
    groups: ["my_group_groups_1", "my_group_groups_"]

group_groups:
  - my_group_groups_1
  - my_group_groups_2
```

## Variable definition for host users
host_vars/my_ansible_hostname.yaml file

```
host_users:
  user_4:
    groups: ["sudo"]

host_groups: {}

 ```


## Variable definition for users info

user_info:
  user_1:
    shell: /bin/bash
    uid: 10100
    ssh_keys: []
  user_2:
    shell: /bin/bash
    uid: 10101
    ssh_keys:
      - ssh-rsa +5CSRh8rtGzgnOUthsHDfZLFiPcMfwNcGzi/BcSb3WAPJkLI+rdo8OtoSWRl8sEU3ibzqhCUS9eKho296dvHT82pIU2CDKBFoYlMsny/BrnZzK1CncMoibPZrSS3cDmBP7BQqV3amhQEDBpoFLWSbawXcueAxBXX2QuMCpwksqrq9DBr6LwlxmywMZmyJP9rwF9jBJcr2NG7yH8A51dDnR7LEWoTyf39GJ3OEdHS6wpYHw/fWvWKaKFn0siY1Z6RhiVjkbXJOLJ9wd9n6uPrGA1ehCASQQsMRdk6QPXnRNGc=
      - ssh-rsa ASvycMYYeKRtVoXIpKZuEGfk5JPUceMFp3vWo1RDuVvOWrBrXW1QJcTOwtO3WpJxlVxkN6lFme+qjxOBM0HdQ7S+oavqnyzKhwbt9b+5CSRh8rtGzgnOUthsHDfZLFiPcMfwNcGzi/BcSb3WAPJkLI+rdo8OtoSWRl8sEU3ibzqhCUS9eKho296dvHT82pIU2CDKBFoYlMsny/BrnZzK1CncMoibPZrSS3cDmBP7BQqV3amhQEDBpoFLWSbawXcueAxBXX2QuMCpwksqrq9DBr6LwlxmywMZmyJP9rwF9jBJcr2NG7yH8A51dDnR7LEWoTyf39GJ3OEdHS6wpYHw/fWvWKaKFn0siY1Z6RhiVjkbXJOLJ9wd9n6uPrGA1ehCASQQsMRdk6QPXnRNGc=
  user_3:
    shell: /bin/bash
    uid: 10102
    ssh_keys: []
  user_4:
    shell: /bin/bash
    uid: 10103
    ssh_keys: []

## Variable definition for groups info
group_info:
  my_global_group_1:
    gid: 1111
  my_global_group_1:
    gid: 1112
  my_group_groups_1:
    gid: 1113
  my_group_groups_2:
    gid: 1114