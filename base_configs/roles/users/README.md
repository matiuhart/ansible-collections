# Users role
To create this role I have used the official [Ansible user module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html)

This playbook creates, removes, adds users to groups and pub keys for linux users. As default creates the users without password if you doest'n specify it
To add the pub keys, you should create a file with the key content using same user name and _.pub_ extention as file name (ej: user1.pub) in _/files/ssh/pub_keys/_ path. If you wish to define a custom pub keys path you will need to define the keys path at _pub_keys_path_ variable described bellow.

### Attention
By default is disabling ssh root login


### Variables

|   Variable    |  Description           |  Default Value  |
| ------------- | ---------------------- | --------------- |
| users         | Users dictionary       |      None       |
| remove_users  | Remove Users list      |      None       |
| pub_keys_path | Path to pub keys files | {{ inventory_dir }}/files/ssh/pub_keys |


### Example definition
In the following example, I am defining a custom path for keys, creating two users without passwords, adding these to groups, also I am removing user3

```
pub_keys_path: my/ssh/key/path"

users:
  - username: "user1"
    password: "*"
    groups:
      - sudo
      - docker
  - username: "user2"
    password: "*"
    groups:
      - sudo

remove_users:
    - user3

```
