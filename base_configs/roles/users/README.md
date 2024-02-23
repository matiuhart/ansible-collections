# Users role
To create this role I have used the official [Ansible user module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html)

This playbook creates, removes, adds users to groups and pub keys for linux users. If you want to create the user without password, you can define the password variable value as empty. 
To add the pub keys, you should create a file with the key content using same user name and _.pub_ extention as file name (ej: user1.pub) in _/files/ssh/pub_keys/_ path. To define a custom pub keys path you will need to define the keys path at _pub_keys_path_ variable described bellow.

### Attention
By default is disabling ssh root login


### Variables

|   Variable    |  Description           |  Default Value  |
| ------------- | ---------------------- | --------------- |
| users         | Users dictionary       |      None       |
| remove_users  | Remove Users list      |      None       |
| pub_keys_path | Path to pub keys files | {{ inventory_dir }}/files/ssh/pub_keys |


### Example definition
In the following example, I am defining a custom path for keys, creating two users, adding it to groups, also I am removing user3. 

```
pub_keys_path: my/ssh/key/path"

users:
  # Example defining user without password
  - username: "user1"
    password: 
    groups:
      - sudo
      - docker
  # Example defining shadow password. See hints to generate shadow pass or copy it from /etc/shadow
  - username: "user2"
    password: "$6$xyz$VKswtvLoVpOLcpjDMIFXhxa8ukqqKSKHjcPBLZUk9NxWldmlFQY4stUGo." 
    groups:
      - sudo

remove_users:
    - user3

```
### Hints
#### Create a shadow password

```
openssl passwd -6 -salt xyz yourpass
```