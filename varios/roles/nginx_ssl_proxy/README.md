# Use this as a full example of applicable variables
This is a reverse proxy with an auto SSL management solution based on nginx, certbox, and letsencrypt (with nginx type validation).

Role Variables
--------------

| Variable | Default Value | Requeried | Description |
| ----------- | ----------- | -------- | ----------- |
| vhost_name | None | yes| DNS fqdn server hostname (used for nginx site and cert generation) |
| https | true | if you want https enabled | Enable/Disable https site |
| aditional_vhost_names | None | no | Aditional nginx hostname (not used for cert generation)|
| proxy_pass_host | 127.0.0.1 | no | Destination server IP/hostname for forwarding the traffic |
| proxy_pass_port | None | yes | Destinantion server port for forwarding the traffic |
| extra_http_local_root_site_configs | None | no | Additionals http site configs |
| extra_https_local_root_site_configs | None | no | Additionals https site configs |


Example Playbook
----------------

```
- name: Proxy server management
  hosts: my_proxy_server
  become: true
  connection: ssh
  vars:
    certbot_admin_email: youremail@email.com
    vhosts:
      - vhost_name: myserver1.mydomain.com
        https: true
        aditional_vhost_names: myserver1alias.mydomain.com
        proxy_pass_host: 127.0.0.1
        proxy_pass_port: 8001
        extra_http_local_root_site_configs:
        extra_https_local_root_site_configs: |-
          allow 192.168.10.20/24;
          allow 50.17.90.91/32;
          deny all;
    
      - vhost_name: myserver2.mydomain.com
        proxy_pass_port: 81
        proxy_pass_host: 192.168.10.9
        extra_https_local_root_site_configs: |-
          rewrite ^/(.*) /admin/$1 break;
          
          allow 192.168.0.0/24;
          allow 50.17.90.91/32;
          deny all;
roles:
  - nginx_ssl_proxy
```
