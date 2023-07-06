# Collections para ansible
Este repositorio fue creado con el fin de simplificar la administracion de roles que se utilizan habitialmente. Cree colleciones de roles por tipo de configuraciones aplicadas. Para uitlizar esta collection es necesario Ansible version 2.10 o superior.
## Dependencias
Antes de poder utilizar estas collections es necesario instalar otras collections que son dependencias
ansible-galaxy collection install  community.general -p collections
ansible-galaxy collection install  community.windows -p collections
ansible-galaxy collection install  ansible.posix -p collections

## Instalar collections desde repositorio git
Se están utilizando collections para simplificar el mantenimiento de los roles, podemos instalarlas de la siguiente forma

**Instala todas las collections que existen en repo**

*Via ssh*
```
ansible-galaxy collection install --upgrade git@github.com:matiuhart/ansible-collections.git -p collections
```

*Via https*

```
ansible-galaxy collection install git+https://github.com/matiuhart/ansible-collections.git -p collections
```

**Instala solo la base_configs desde el repo**

```
ansible-galaxy collection install git@github.com:matiuhart/ansible-collections.git#/base_configs -p collections
```

**Instala la base_configs desde el commit especificado**

```
ansible-galaxy collection install git@github.com:matiuhart/ansible-collections.git#/base_configs,7b60ddc245bc416b72d8ea6ed7b799885110f5e5 -p collections
```

## Actualizar collections

```
ansible-galaxy collection install --upgrade git@github.com:matiuhart/ansible-collections.git
```

## Como utilizar
Dentro del playbook podemos referenciar un rol dentro de las collections de estas dos maneras

**Import con nombre corto**

```
- name: Playbook de ejemplo para collections
  hosts: all 
  become: true
  connection: ssh
  collections:
    - matiuhart.base_configs
  vars_files: 
    - ../vault/sudo.yaml
    - ../vault/docker03.yaml
  
  roles:
    - docker_install
    - base_packages_and_configs
    - nginx_ssl_proxy

  tasks:
    - import_role:
        name: users  <----- Rol dentro de la collecction matiuhart.base_configs
```

**Import con nombre completo**

```
- name: Playbooks para servidor Docker03
  hosts: all 
  become: true
  connection: ssh
  vars_files: 
    - ../vault/sudo.yaml
    - ../vault/docker03.yaml
  
  roles:
    - docker_install
    - base_packages_and_configs
    - nginx_ssl_proxy

  tasks:
    - import_role:
        name: matiuhart.base_configs.users
```

**Include de varios roles con loop**

```
- name: Playbooks para servidor Docker03
  hosts: all 
  become: true
  connection: ssh
  vars_files: 
    - ../vault/sudo.yaml
    - ../vault/docker03.yaml
  
  roles:
    - docker_install
    - base_packages_and_configs
    - nginx_ssl_proxy
  
  tasks:
    - name: Importado de roles base
      include_role:
        name: "{{ role_name }}"
      loop:
        - matiuhart.base_configs.users
        - matiuhart.base_configs.base_packages_and_configs
        - matiuhart.docker.docker_install
        - matiuhart.dbs.mysql
        - matiuhart.dbs.mysql_backups
      loop_control:
        loop_var: role_name
```
