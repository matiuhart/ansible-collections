#
## nginx_ssl_proxy role vars
#
certbot_admin_email: youremail@email.com

vhosts:
  # Use this as full example applicable variables
  - vhost_name: myserver1.mydomain.com
    https: (true  as default if is not defined)
    aditional_vhost_names: myserver1alias.mydomain.com
    proxy_pass_host: (127.0.0.1 as default if is not defined)
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
