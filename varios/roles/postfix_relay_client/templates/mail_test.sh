#!/bin/bash
echo "Testeando relay desde {{ansible_hostname}} a traves de {{relay_server}} " | mail -s "Prueba de correo" -a "From: {{relay_user}}" {{dst_mail_test}}